const PROTOCOL = "https";

// Events
const UI_LOADED = "ui_loaded";

const post = (name, data) => {
  $.post(`${PROTOCOL}://local_storage/${name}`, JSON.stringify(data || {}));
};

const get = (key) => {
  return localStorage.getItem(key);
};

const set = (key, value) => {
  localStorage.setItem(key, value);
  return true;
};

const remove = (key) => {
  localStorage.removeItem(key);
  return true;
};

const clear = () => {
  localStorage.clear();
  return true;
};

$(document).ready(() => {
  post(UI_LOADED);

  window.addEventListener("message", (event) => {
    switch (event.data.action) {
      case "get":
        post("get", {
          ...event.data,
          callback: get(event.data.key),
        });
        break;
      case "set":
        post("set", {
          ...event.data,
          callback: set(event.data.key, event.data.value),
        });
        break;
      case "remove":
        post("remove", {
          ...event.data,
          callback: remove(event.data.key),
        });
        break;
      case "clear":
        post("clear", {
          ...event.data,
          callback: clear(),
        });
        break;
      default:
        console.log(`Unknown action: ${event.data.action}`);
        break;
    }
  });
});
