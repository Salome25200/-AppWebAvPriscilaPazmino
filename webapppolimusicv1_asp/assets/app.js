(function () {
  "use strict";
  var toastRegion = document.getElementById("toast-region");
  function toast(message) {
    if (!toastRegion || !message) return;
    var item = document.createElement("div");
    item.className = "toast";
    item.textContent = message;
    toastRegion.appendChild(item);
    window.setTimeout(function () { if (item.parentNode) item.parentNode.removeChild(item); }, 4200);
  }

  var menu = document.querySelector(".sidebar");
  var menuButton = document.querySelector("[data-menu-toggle]");
  if (menu && menuButton) {
    menuButton.addEventListener("click", function () {
      var open = menu.classList.toggle("open");
      menuButton.setAttribute("aria-expanded", String(open));
    });
  }

  var audio = document.getElementById("appAudio");
  var current = document.getElementById("nowSong");
  var buttons = document.querySelectorAll(".play-song");
  var activeButton = null;
  function updatePlaybackButtons() {
    Array.prototype.forEach.call(buttons, function (button) {
      var playing = button === activeButton && audio && !audio.paused;
      var title = button.getAttribute("data-title") || "canción";
      button.setAttribute("aria-pressed", String(Boolean(playing)));
      button.setAttribute("aria-label", (playing ? "Pausar " : "Reproducir ") + title);
      button.querySelector(".play-icon").textContent = playing ? "❚❚" : "▶";
      button.querySelector(".play-label").textContent = playing ? "Pausar" : "Reproducir";
    });
  }
  Array.prototype.forEach.call(buttons, function (button) {
    button.addEventListener("click", function () {
      if (!audio) return;
      var source = button.getAttribute("data-audio");
      var title = button.getAttribute("data-title") || "Canción seleccionada";
      if (button === activeButton && !audio.paused) {
        audio.pause();
        return;
      }
      if (button !== activeButton) {
        activeButton = button;
        if (audio.src !== new URL(source, document.baseURI).href) audio.src = source;
        else audio.currentTime = 0;
      }
      if (current) current.textContent = title;
      audio.play().then(function () {
          updatePlaybackButtons();
          var id = button.getAttribute("data-song-id");
          if (id && window.fetch) window.fetch("play.asp?id=" + encodeURIComponent(id), { credentials: "same-origin" }).catch(function () {});
      }).catch(function () { toast("No fue posible reproducir el archivo de audio."); updatePlaybackButtons(); });
    });
  });
  if (audio) {
    audio.addEventListener("play", updatePlaybackButtons);
    audio.addEventListener("pause", updatePlaybackButtons);
    audio.addEventListener("ended", updatePlaybackButtons);
  }

  var reveal = document.querySelector("[data-password-toggle]");
  if (reveal) reveal.addEventListener("click", function () {
    var input = document.getElementById("password");
    if (!input) return;
    var showing = input.type === "text";
    input.type = showing ? "password" : "text";
    reveal.setAttribute("aria-pressed", String(!showing));
    reveal.setAttribute("aria-label", showing ? "Mostrar contraseña" : "Ocultar contraseña");
    reveal.textContent = showing ? "◉" : "◌";
    input.focus();
  });

  var dialog = document.getElementById("deleteDialog");
  var deleteInput = document.getElementById("deleteId");
  var deleteName = document.getElementById("deleteName");
  var lastTrigger = null;
  Array.prototype.forEach.call(document.querySelectorAll("[data-delete-id]"), function (trigger) {
    trigger.addEventListener("click", function () {
      if (!dialog) return;
      lastTrigger = trigger;
      if (deleteInput) deleteInput.value = trigger.getAttribute("data-delete-id");
      if (deleteName) deleteName.textContent = trigger.getAttribute("data-delete-name") || "este registro";
      dialog.classList.add("open");
      var appShell = document.querySelector(".app-shell");
      if (appShell) appShell.setAttribute("aria-hidden", "true");
      var cancel = dialog.querySelector("[data-dialog-cancel]");
      if (cancel) cancel.focus();
    });
  });
  function closeDialog() {
    if (dialog) dialog.classList.remove("open");
    var appShell = document.querySelector(".app-shell");
    if (appShell) appShell.removeAttribute("aria-hidden");
    if (lastTrigger) lastTrigger.focus();
  }
  if (dialog) {
    var cancelButton = dialog.querySelector("[data-dialog-cancel]");
    if (cancelButton) cancelButton.addEventListener("click", closeDialog);
    dialog.addEventListener("click", function (event) { if (event.target === dialog) closeDialog(); });
    document.addEventListener("keydown", function (event) {
      if (!dialog.classList.contains("open")) return;
      if (event.key === "Escape") { closeDialog(); return; }
      if (event.key === "Tab") {
        var focusable = dialog.querySelectorAll("button, [href], input:not([type=hidden])");
        if (!focusable.length) return;
        var first = focusable[0];
        var last = focusable[focusable.length - 1];
        if (event.shiftKey && document.activeElement === first) { event.preventDefault(); last.focus(); }
        else if (!event.shiftKey && document.activeElement === last) { event.preventDefault(); first.focus(); }
      }
    });
  }
  Array.prototype.forEach.call(document.querySelectorAll("form[data-busy-form]"), function (form) {
    form.addEventListener("submit", function () {
      var submit = form.querySelector("button[type=submit]");
      if (submit && form.checkValidity()) { submit.disabled = true; submit.setAttribute("aria-busy", "true"); }
    });
  });
}());
