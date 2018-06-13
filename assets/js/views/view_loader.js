
import MainView    from './main';
import RoomShowView from './room_show';
import UserShowView from './user_show';

// Collection of specific view modules
const views = {
  "room_show": RoomShowView,
  "user_show": UserShowView
};

export default function loadView(viewName) {
  return views[viewName] || MainView;
}
