/*
 * Carrd runtime adapter for Hugo multipage templates.
 * Ensures Carrd's main.js can initialize even on pages that do not render
 * cover slider or video sections.
 */
(function () {
  function ensureHiddenStyle() {
    if (document.getElementById("carrd-runtime-stub-style")) return;

    var style = document.createElement("style");
    style.id = "carrd-runtime-stub-style";
    style.textContent =
      ".carrd-runtime-stub{display:none!important;visibility:hidden!important;pointer-events:none!important;}";
    document.head.appendChild(style);
  }

  function ensureCoverSliderStub() {
    if (document.getElementById("coverSlider")) return;

    var stub = document.createElement("div");
    stub.id = "coverSlider";
    stub.className =
      "container-component instance-14 columns carrd-runtime-stub";
    stub.setAttribute("aria-hidden", "true");
    stub.setAttribute("data-runtime-stub", "coverSlider");
    document.body.appendChild(stub);
  }

  function ensureVideoStub() {
    if (document.getElementById("video02")) return;

    var video = document.createElement("div");
    video.id = "video02";
    video.className = "video-component carrd-runtime-stub";
    video.setAttribute("aria-hidden", "true");
    video.setAttribute("data-runtime-stub", "video02");

    var frame = document.createElement("div");
    frame.className = "frame";

    var thumbnail = document.createElement("div");
    thumbnail.className = "player thumbnail";

    frame.appendChild(thumbnail);
    video.appendChild(frame);
    document.body.appendChild(video);
  }

  ensureHiddenStyle();
  ensureCoverSliderStub();
  ensureVideoStub();
})();
