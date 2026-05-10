// update-mimeapps generates ~/.config/mimeapps.list from a user-managed
// defaults.yaml, enforcing preferred app associations that survive system
// updates. It scans installed .desktop files, supports wildcard patterns
// (e.g. "image/*") and exact overrides, self-cleans stale entries from
// defaults.yaml, and writes both [Default Applications] and
// [Added Associations] sections.
//
// Invocation: run the fish wrapper at bin/update-mimeapps from the dotfiles root.
// Configuration: edit mimeapps/defaults.yaml.
package main

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strings"

	"gopkg.in/yaml.v3"
)

var searchPaths = []string{
	"~/.nix-profile/share/applications",
	"/run/current-system/sw/share/applications",
	"/usr/share/applications",
	"~/.local/share/applications",
}

func expandHome(path string) string {
	if !strings.HasPrefix(path, "~/") {
		return path
	}
	home, err := os.UserHomeDir()
	if err != nil {
		panic(err)
	}
	return filepath.Join(home, path[2:])
}

// resolveDefaultsPath finds defaults.yaml relative to the binary (compiled use)
// or relative to the working directory (go run use).
func resolveDefaultsPath() string {
	if path := os.Getenv("MIMEAPPS_CONFIG_PATH"); path != "" {
		return path
	}
	if exe, err := os.Executable(); err == nil {
		if real, err := filepath.EvalSymlinks(exe); err == nil {
			candidate := filepath.Clean(filepath.Join(filepath.Dir(real), "..", "mimeapps", "defaults.yaml"))
			if _, err := os.Stat(candidate); err == nil {
				return candidate
			}
			// When run via 'go run', the executable is in a temp dir.
			// Try looking up two levels if the above fails.
			candidate = filepath.Clean(filepath.Join(filepath.Dir(real), "..", "..", "mimeapps", "defaults.yaml"))
			if _, err := os.Stat(candidate); err == nil {
				return candidate
			}
		}
	}
	cwd, _ := os.Getwd()
	// Try root-relative
	candidate := filepath.Join(cwd, "mimeapps", "defaults.yaml")
	if _, err := os.Stat(candidate); err == nil {
		return candidate
	}
	// Try relative to bin/
	candidate = filepath.Join(cwd, "..", "mimeapps", "defaults.yaml")
	if _, err := os.Stat(candidate); err == nil {
		return candidate
	}

	return filepath.Join(cwd, "mimeapps", "defaults.yaml") // Default fallback
}

type appConfig struct {
	DefaultApplications map[string]string `yaml:"Default Applications"`
}

type generator struct {
	mimetypeToApps   map[string]map[string]bool
	availableApps    map[string]bool
	exactDefaults    map[string]string
	wildcardDefaults map[string]string
	finalDefaults    map[string]string
	defaultsPath     string
	outputPath       string
}

func newGenerator() *generator {
	return &generator{
		mimetypeToApps:   make(map[string]map[string]bool),
		availableApps:    make(map[string]bool),
		exactDefaults:    make(map[string]string),
		wildcardDefaults: make(map[string]string),
		finalDefaults:    make(map[string]string),
		defaultsPath:     resolveDefaultsPath(),
		outputPath:       expandHome("~/.config/mimeapps.list"),
	}
}

func (g *generator) run() {
	fmt.Println("🚀 Starting mimeapps.list generation...")
	g.scanDesktopFiles()
	g.cleanUserDefaults()
	g.loadUserDefaults()
	g.resolveDefaults()
	g.writeOutput()
	fmt.Printf("✅ Successfully generated %s\n", g.outputPath)
}

func (g *generator) scanDesktopFiles() {
	fmt.Println("🔍 Scanning for .desktop files...")
	for _, sp := range searchPaths {
		path := expandHome(sp)
		if _, err := os.Stat(path); os.IsNotExist(err) {
			continue
		}
		_ = filepath.Walk(path, func(p string, info os.FileInfo, err error) error {
			if err != nil || info.IsDir() || !strings.HasSuffix(p, ".desktop") {
				return nil
			}
			g.processDesktopFile(p)
			return nil
		})
	}
	fmt.Printf("   Found %d unique mimetypes from %d applications.\n",
		len(g.mimetypeToApps), len(g.availableApps))
}

func (g *generator) processDesktopFile(path string) {
	data, err := os.ReadFile(path)
	if err != nil {
		return
	}
	content := string(data)
	if strings.Contains(content, "NoDisplay=true") {
		return
	}
	mimetypes := extractMimetypes(content)
	if len(mimetypes) == 0 {
		return
	}
	appName := filepath.Base(path)
	g.availableApps[appName] = true
	for _, mime := range mimetypes {
		mime = strings.ToLower(strings.TrimSpace(mime))
		if mime == "" {
			continue
		}
		if g.mimetypeToApps[mime] == nil {
			g.mimetypeToApps[mime] = make(map[string]bool)
		}
		g.mimetypeToApps[mime][appName] = true
	}
}

func extractMimetypes(content string) []string {
	scanner := bufio.NewScanner(strings.NewReader(content))
	for scanner.Scan() {
		line := scanner.Text()
		if !strings.HasPrefix(line, "MimeType=") {
			continue
		}
		var result []string
		for _, part := range strings.Split(strings.TrimPrefix(line, "MimeType="), ";") {
			if p := strings.TrimSpace(part); p != "" {
				result = append(result, p)
			}
		}
		return result
	}
	return nil
}

func (g *generator) cleanUserDefaults() {
	if _, err := os.Stat(g.defaultsPath); os.IsNotExist(err) {
		return
	}
	fmt.Println("🧹 Cleaning defaults.yaml of uninstalled applications...")

	data, err := os.ReadFile(g.defaultsPath)
	must(err)
	var cfg appConfig
	must(yaml.Unmarshal(data, &cfg))
	if cfg.DefaultApplications == nil {
		return
	}

	originalCount := len(cfg.DefaultApplications)
	for mime, app := range cfg.DefaultApplications {
		if !g.availableApps[app] {
			delete(cfg.DefaultApplications, mime)
		}
	}
	if removed := originalCount - len(cfg.DefaultApplications); removed > 0 {
		fmt.Printf("   Removed %d obsolete entries.\n", removed)
	}

	must(writeYAML(g.defaultsPath, &cfg))
}

func (g *generator) loadUserDefaults() {
	if _, err := os.Stat(g.defaultsPath); os.IsNotExist(err) {
		return
	}
	fmt.Printf("⚙️  Loading user defaults from %s...\n", g.defaultsPath)

	data, err := os.ReadFile(g.defaultsPath)
	must(err)
	var cfg appConfig
	must(yaml.Unmarshal(data, &cfg))

	for key, value := range cfg.DefaultApplications {
		if strings.Contains(key, "*") {
			g.wildcardDefaults[key] = value
		} else {
			g.exactDefaults[key] = value
		}
	}
}

func (g *generator) resolveDefaults() {
	fmt.Println("🧠 Resolving final default applications...")

	// Case-insensitive matching is required because vendors are inconsistent
	// (e.g. macroEnabled vs macroenabled). Without it, wildcards silently miss
	// sub-types and a secondary app bleeds in as the effective default.
	for mime := range g.mimetypeToApps {
		for pattern, app := range g.wildcardDefaults {
			if matched, _ := filepath.Match(strings.ToLower(pattern), strings.ToLower(mime)); matched {
				g.finalDefaults[mime] = app
			}
		}
	}
	for mime, app := range g.exactDefaults {
		g.finalDefaults[mime] = app
	}
}

func (g *generator) writeOutput() {
	fmt.Printf("✍️  Generating new %s...\n", filepath.Base(g.outputPath))

	var sb strings.Builder
	sb.WriteString("# This file is auto-generated by the update-mimeapps.go script.\n")
	sb.WriteString("# Do not edit directly. Your defaults are managed in:\n")
	fmt.Fprintf(&sb, "# %s\n\n\n", g.defaultsPath)

	sb.WriteString("[Default Applications]\n")
	for _, mime := range sortedKeys(g.finalDefaults) {
		fmt.Fprintf(&sb, "%s=%s\n", mime, g.finalDefaults[mime])
	}

	sb.WriteString("\n[Added Associations]\n")
	for _, mime := range sortedKeys(g.mimetypeToApps) {
		apps := sortedKeys(g.mimetypeToApps[mime])
		apps = prioritizeApp(apps, g.finalDefaults[mime])
		fmt.Fprintf(&sb, "%s=%s;\n", mime, strings.Join(apps, ";"))
	}

	must(os.WriteFile(g.outputPath, []byte(sb.String()), 0o644))
}

// prioritizeApp moves defaultApp to the front of the associations list.
// This adds layered redundancy on top of [Default Applications]:
//   - Spec fallback: many tools use the first [Added Associations] entry when
//     [Default Applications] is absent or ignored.
//   - UI order: file managers (Nautilus, Yazi) build "Open With" menus from
//     this list, so the intended default always appears first.
//   - Hijack prevention: stops secondary apps (e.g. Calibre) from being
//     erroneously promoted by the system over the preferred default.
func prioritizeApp(apps []string, defaultApp string) []string {
	if defaultApp == "" {
		return apps
	}
	result := make([]string, 0, len(apps))
	result = append(result, defaultApp)
	for _, app := range apps {
		if app != defaultApp {
			result = append(result, app)
		}
	}
	return result
}

func sortedKeys[V any](m map[string]V) []string {
	keys := make([]string, 0, len(m))
	for k := range m {
		keys = append(keys, k)
	}
	sort.Strings(keys)
	return keys
}

// writeYAML marshals v as YAML with 2-space indentation.
// yaml.Encoder prepends "---\n"; we strip it for a clean file.
func writeYAML(path string, v any) error {
	var buf bytes.Buffer
	enc := yaml.NewEncoder(&buf)
	enc.SetIndent(2)
	if err := enc.Encode(v); err != nil {
		return err
	}
	if err := enc.Close(); err != nil {
		return err
	}
	out := bytes.TrimPrefix(buf.Bytes(), []byte("---\n"))
	return os.WriteFile(path, out, 0o644)
}

func must(err error) {
	if err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1)
	}
}

func main() {
	newGenerator().run()
}
