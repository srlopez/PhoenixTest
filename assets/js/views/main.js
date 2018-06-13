// assets/js/views/main.js
import gchannel from "../app" //Global channel

export default class MainView {
  mount() {
    // This will be executed when the document loads...
    console.log('MainView mounted');
    gchannel.push("enter_view", { view: document.getElementsByTagName('body')[0].dataset.jsViewName })


  }

  unmount() {
    // This will be executed when the document unloads...
    console.log('MainView unmounted');
  }
}
