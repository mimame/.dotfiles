//
/* You may copy+paste this file and use it as it is.
 *
 * If you make changes to your about:config while the program is running, the
 * changes will be overwritten by the user.js when the application restarts.
 *
 * To make lasting changes to preferences, you will have to edit the user.js.
 */

/****************************************************************************
 * Betterfox                                                                *
 * "Ad meliora"                                                             *
 * version: 148                                                             *
 * url: https://github.com/yokoffing/Betterfox                              *
****************************************************************************/

/****************************************************************************
 * SECTION: FASTFOX                                                         *
****************************************************************************/
user_pref("gfx.webrender.layer-compositor", false);
user_pref("gfx.canvas.accelerated.cache-items", 32768); // items; default=2048
user_pref("gfx.canvas.accelerated.cache-size", 4096); // MB; default=256
user_pref("webgl.max-size", 16384); // MB; default=4096

/** DISK CACHE ***/
user_pref("browser.cache.disk.enable", false);

/** MEMORY CACHE ***/
user_pref("browser.cache.memory.capacity", 1048576); // KB; 1GB cache
user_pref("browser.cache.memory.max_entry_size", 131072); // KB; 128MB max entry size
user_pref("browser.sessionhistory.max_total_viewers", 10); // items; number of pages kept in memory for back/forward
user_pref("browser.sessionstore.max_tabs_undo", 30); // items; number of closed tabs to remember

/** MEDIA CACHE ***/
user_pref("media.memory_cache_max_size", 1048576); // KB; 1GB media cache
user_pref("media.memory_caches_combined_limit_kb", 2097152); // KB; 2GB total limit
user_pref("media.cache_readahead_limit", 1200); // seconds; amount of media to buffer ahead
user_pref("media.cache_resume_threshold", 600); // seconds; amount of media to buffer before resuming

/** IMAGE CACHE ***/
user_pref("image.cache.size", 1073741824); // bytes; 1GB image cache
user_pref("image.mem.decode_bytes_at_a_time", 131072); // bytes; chunk size for image decoding

/** NETWORK ***/
user_pref("network.http.max-connections", 1800); // connections
user_pref("network.http.max-persistent-connections-per-server", 10); // connections
user_pref("network.http.max-urgent-start-excessive-connections-per-host", 5); // connections
user_pref("network.http.request.max-start-delay", 5); // seconds
user_pref("network.http.pacing.requests.enabled", false);
user_pref("network.dnsCacheEntries", 10000); // entries
user_pref("network.dnsCacheExpiration", 3600); // seconds; 1 hour
user_pref("network.ssl_tokens_cache_capacity", 10240); // entries

/** SPECULATIVE LOADING ***/
user_pref("network.http.speculative-parallel-limit", 0);
user_pref("network.dns.disablePrefetch", true);
user_pref("network.dns.disablePrefetchFromHTTPS", true);
user_pref("browser.urlbar.speculativeConnect.enabled", false);
user_pref("browser.places.speculativeConnect.enabled", false);
user_pref("network.prefetch-next", false);

/****************************************************************************
 * SECTION: SECUREFOX                                                       *
****************************************************************************/
/** TRACKING PROTECTION ***/
user_pref("browser.contentblocking.category", "strict");
user_pref("browser.download.start_downloads_in_tmp_dir", false);
user_pref("browser.uitour.enabled", false);
user_pref("privacy.globalprivacycontrol.enabled", true);

/** OCSP & CERTS / HPKP ***/
user_pref("security.OCSP.enabled", 0);
user_pref("privacy.antitracking.isolateContentScriptResources", true);
user_pref("security.csp.reporting.enabled", false);

/** SSL / TLS ***/
user_pref("security.ssl.treat_unsafe_negotiation_as_broken", true);
user_pref("browser.xul.error_pages.expert_bad_cert", true);
user_pref("security.tls.enable_0rtt_data", false);

/** DISK AVOIDANCE ***/
user_pref("browser.privatebrowsing.forceMediaMemoryCache", true);
user_pref("browser.sessionstore.interval", 60000); // ms; 1 minute

/** SHUTDOWN & SANITIZING ***/
user_pref("privacy.history.custom", true);
user_pref("browser.privatebrowsing.resetPBM.enabled", true);

/** SEARCH / URL BAR ***/
user_pref("browser.urlbar.trimHttps", true);
user_pref("browser.urlbar.untrimOnUserInteraction.featureGate", true);
user_pref("browser.search.separatePrivateDefault.ui.enabled", true);
user_pref("browser.search.suggest.enabled", false);
user_pref("browser.urlbar.quicksuggest.enabled", false);
user_pref("browser.urlbar.groupLabels.enabled", false);
user_pref("browser.formfill.enable", false);
user_pref("network.IDN_show_punycode", true);

/** HTTPS-ONLY MODE ***/
user_pref("dom.security.https_only_mode", true);
user_pref("dom.security.https_only_mode_error_page_user_suggestions", true);

/** PASSWORDS ***/
user_pref("signon.formlessCapture.enabled", false);
user_pref("signon.privateBrowsingCapture.enabled", false);
user_pref("network.auth.subresource-http-auth-allow", 1); // allow auth on subresources
user_pref("editor.truncate_user_pastes", false);

/** EXTENSIONS ***/
user_pref("extensions.enabledScopes", 5); // control where extensions can be installed

/** HEADERS / REFERERS ***/
user_pref("network.http.referer.XOriginTrimmingPolicy", 2);

/** CONTAINERS ***/
user_pref("privacy.userContext.ui.enabled", true);

/** SAFE BROWSING ***/
user_pref("browser.safebrowsing.downloads.remote.enabled", false);

/** MOZILLA ***/
user_pref("permissions.default.desktop-notification", 2); // 2=block by default
user_pref("permissions.default.geo", 2); // 2=block by default
user_pref("geo.provider.network.url", "https://beacondb.net/v1/geolocate");
user_pref("browser.search.update", false);
user_pref("permissions.manager.defaultsUrl", "");
user_pref("extensions.getAddons.cache.enabled", false);

/** TELEMETRY ***/
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.server", "data:,");
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref("toolkit.telemetry.coverage.opt-out", true);
user_pref("toolkit.coverage.opt-out", true);
user_pref("toolkit.coverage.endpoint.base", "");
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);
user_pref("datareporting.usage.uploadEnabled", false);

/** EXPERIMENTS ***/
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");

/** CRASH REPORTS ***/
user_pref("breakpad.reportURL", "");
user_pref("browser.tabs.crashReporting.sendReport", false);

/****************************************************************************
 * SECTION: PESKYFOX                                                        *
****************************************************************************/
/** MOZILLA UI ***/
user_pref("extensions.getAddons.showPane", false);
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
user_pref("browser.discovery.enabled", false);
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
user_pref("browser.preferences.moreFromMozilla", false);
user_pref("browser.aboutConfig.showWarning", false);
user_pref("browser.startup.homepage_override.mstone", "ignore");
user_pref("browser.aboutwelcome.enabled", false);
user_pref("browser.profiles.enabled", true);

/** THEME ADJUSTMENTS ***/
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("browser.compactmode.show", true);
user_pref("browser.privateWindowSeparation.enabled", false); // WINDOWS

/** FULLSCREEN NOTICE ***/
user_pref("full-screen-api.transition-duration.enter", "0 0");
user_pref("full-screen-api.transition-duration.leave", "0 0");
user_pref("full-screen-api.warning.timeout", 0); // ms; no delay

/** URL BAR ***/
user_pref("browser.urlbar.trending.featureGate", false);

/** NEW TAB PAGE ***/
user_pref("browser.newtabpage.activity-stream.default.sites", "");
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredCheckboxes", false);

/** DOWNLOADS ***/
user_pref("browser.download.manager.addToRecentDocs", false);

/** PDF ***/
user_pref("pdfjs.disabled", true);
user_pref("browser.download.open_pdf_attachments_inline", false);
user_pref("browser.helperApps.showOpenOptionForPdfJS", false);

/** TAB BEHAVIOR ***/
user_pref("browser.bookmarks.openInTabClosesMenu", false);
user_pref("browser.menu.showViewImageInfo", true);
user_pref("findbar.highlightAll", true);
user_pref("layout.word_select.eat_space_to_next_word", false);

/****************************************************************************
 * START: MY OVERRIDES                                                      *
****************************************************************************/
// visit https://github.com/yokoffing/Betterfox/wiki/Common-Overrides
// visit https://github.com/yokoffing/Betterfox/wiki/Optional-Hardening
// Enter your personal overrides below this line:

/** FASTFOX ***/
user_pref("gfx.webrender.all", true); // Force hardware acceleration
user_pref("nglayout.initialpaint.delay", 0); // ms; default=250; start rendering immediately
user_pref("content.notify.interval", 100000); // microseconds; 0.1s; reduces frequency of UI updates during page load
user_pref("browser.startup.preXULSkeletonUI", false); // Linux: prevents potential flicker/glitches

/** SECUREFOX ***/
user_pref("network.dns.echconfig.enabled", true); // Enable Encrypted Client Hello
user_pref("network.dns.http3_echconfig.enabled", true);
user_pref("network.trr.mode", 2); // 2=DoH with fallback; 3=Strict DoH; 5=Disabled
user_pref("network.trr.uri", "https://mozilla.cloudflare-dns.com/dns-query");

/** PESKYFOX ***/
user_pref("browser.uidensity", 1); // 1=compact mode
user_pref("browser.tabs.loadInBackground", true);
user_pref("browser.search.suggest.enabled", true); // Restore search suggestions (optional, but convenient)
user_pref("browser.urlbar.suggest.searches", true);
user_pref("browser.urlbar.showSearchSuggestionsFirst", false);
user_pref("browser.tabs.closeWindowWithLastTab", false); // Linux: keep window open when last tab is closed
user_pref("middlemouse.paste", true); // Linux: enable middle-click paste
user_pref("general.autoScroll", true); // Enable autoscrolling (middle-click + move mouse)
user_pref("dom.ipc.processCount", 16); // items; 16 content processes for better isolation/RAM utilization (32GB)

/** AI ***/
user_pref("browser.ai.control.default", "available");
user_pref("browser.ml.enable", true);
user_pref("browser.ml.chat.enabled", true);
user_pref("browser.ml.chat.menu", true);
user_pref("browser.ml.chat.sidebar", true);
user_pref("browser.tabs.groups.smart.enabled", true);
user_pref("browser.ml.linkPreview.enabled", true);

/****************************************************************************
 * SECTION: SMOOTHFOX                                                       *
 ****************************************************************************/
// visit https://github.com/yokoffing/Betterfox/blob/main/Smoothfox.js
// Enter your scrolling overrides below this line:

// Natural Smooth Scrolling [MODIFIED]
user_pref("general.smoothScroll", true);
user_pref("general.smoothScroll.mouseWheel.durationMinMS", 200); // ms
user_pref("general.smoothScroll.mouseWheel.durationMaxMS", 200); // ms
user_pref("general.smoothScroll.pixelsizeMaxMS", 150); // ms
user_pref("general.smoothScroll.pixelsizeMinMS", 150); // ms
user_pref("general.smoothScroll.scrollbars.durationMinMS", 150); // ms
user_pref("general.smoothScroll.scrollbars.durationMaxMS", 150); // ms
user_pref("general.smoothScroll.touch.durationMinMS", 200); // ms
user_pref("general.smoothScroll.touch.durationMaxMS", 200); // ms
user_pref("mousewheel.default.delta_multiplier_y", 250); // multiplier; Adjust scrolling speed (200-300)

/****************************************************************************
 * END: BETTERFOX                                                           *
****************************************************************************/
