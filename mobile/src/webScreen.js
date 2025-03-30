import {getLinkingObject} from 'react-native-web-screen';

export const Routes = {
  Posts: "Posts",
  CreatePost: "CreatePost",
  ShowPost: "ShowPost",
  EditPost: "EditPost",
  Fallback: "Fallback",
  Pages: "Pages",
  CreateSession: "CreateSession",
  Login: "Login",
  Register: "Register",
  Wastes: "Wastes",
}

export const linkingConfig = {
  screens: {
    [Routes.Posts]: "/posts",
    [Routes.CreatePost]: "posts/new",
    [Routes.EditPost]: "posts/:id/edit",
    [Routes.ShowPost]: "posts/:id",
    [Routes.Fallback]: "*",
    [Routes.Pages]: "/pages",
    [Routes.Login]: "/auth/login",
    [Routes.CreateSession]: "/users/sign_in",
    [Routes.Register]: "/auth/register",
    [Routes.Wastes]: "/wastes",
  },
};

export const baseURL = 'https://picture-it.ngrok.io';

export const linking = getLinkingObject(baseURL, linkingConfig);
