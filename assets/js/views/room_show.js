import MainView from './main';
import { Presence, socket } from "../socket"

export default class View extends MainView {
  mount() {
    super.mount();

    // Specific logic here
    console.log('room-show mounted');
    console.log('eex room.id: '+eex["@room.id"])

    let channel = socket.channel("room:" + eex["@room.id"], {})

    let presences = {};
    let messageInput = document.querySelector("#message-content")
    let messagesContainer = document.querySelector("#messages")
    let onlineUsers = document.querySelector("#online-users")

    const typingTimeout = 2000;
    var typingTimer;
    let userTyping = false;

    channel.join()
      .receive("ok", resp => {
        console.log("Joined successfully! ", resp)
        resp = eval("(" + resp + ")")
        console.log(resp.channel)

      })
      .receive("error", resp => {
        console.log("Unable to join", resp)
      })

    messageInput.addEventListener("keypress", event => {
      if (event.keyCode === 13) {
        setUserTyping(false);
        channel.push("message:add", {
          body: messageInput.value,
          name: eex["@current_user.name"],
          user_id: eex["@current_user.id"],
          room_id: eex["@room.id"]
        })
        messageInput.value = ""
      }
    })

    channel.on("message:new", payload => {
      let messageItem = document.createElement("li")
      //messageItem.innerText = `${payload.name} [${Date()}] ${payload.body}`
      messageItem.innerHTML = `<b>${payload.name}</b>
      <br>
      <small><small><em>${Date()}</em>:</small></small>
        ${payload.body}`
      messagesContainer.insertBefore(messageItem, messagesContainer.childNodes[0]);
    })

    channel.on("presence_state", state => {
      presences = Presence.syncState(presences, state)
      renderOnlineUsers(presences)
    })

    channel.on("presence_diff", diff => {
      presences = Presence.syncDiff(presences, diff)
      renderOnlineUsers(presences)
    })

    const renderOnlineUsers = function(presences) {
      let onlineUsersMarkup = Presence.list(presences, (_id, {
        metas: [user, ...rest]
      }) => {
        var typingIndicator = ''
        //console.dir (user.typing)
        if (user.typing) {
          typingIndicator = ' <i>(typing...)</i>'
        }
        return `
          <div id="online-user-${user.user_id}">
            <strong class="text-secondary">${user.name}</strong> ${typingIndicator}
          </div>`
      }).join("")

      onlineUsers.innerHTML = onlineUsersMarkup;
    }


    messageInput.addEventListener("keydown", event => {
      setUserTyping(true);
      clearTimeout(typingTimer);
    })

    messageInput.addEventListener("keyup", event => {
      // Cada vez que levanta tecla es que teclea, reestablecemos el timer
      clearTimeout(typingTimer);
      typingTimer = setTimeout(setUserTyping(false), typingTimeout);
    })


    const setUserTyping = function(status) {
      if (userTyping == status) {
        return
      }
      userTyping = status

      channel.push('user:typing', {
        typing: status,
        name: eex["@current_user.name"],
      })
    }


  }

  unmount() {
    super.unmount();

    // Specific logic here
    console.log('room-show unmounted');
  }




}
