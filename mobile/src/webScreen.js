import {getLinkingObject} from 'react-native-web-screen';

export const Routes = {
  Posts: "Posts",
  CreatePost: "CreatePost",
  ShowPost: "ShowPost",
  EditPost: "EditPost",
  Fallback: "Fallback",
}

export const linkingConfig = {
  screens: {
    [Routes.Posts]: "/posts",
    [Routes.CreatePost]: "posts/new",
    [Routes.EditPost]: "posts/:id/edit",
    [Routes.ShowPost]: "posts/:id",
    [Routes.Fallback]: "*",
  },
};

export const baseURL = 'https://picture-it.ngrok.io';

export const linking = getLinkingObject(baseURL, linkingConfig);
