import {
  CognitoUserPool,
  CognitoUser,
  AuthenticationDetails,
} from "amazon-cognito-identity-js";

import { cognitoConfig } from "../config/cognitoConfig";

const userPool = new CognitoUserPool({
  UserPoolId: cognitoConfig.userPoolId,
  ClientId: cognitoConfig.clientId,
});

const signUp = (email, password) =>
  new Promise((resolve, reject) => {
    userPool.signUp(email, password, [], null, (err, result) => {
      if (err) return reject(err);
      resolve(result.user);
    });
  });

const signIn = (email, password) =>
  new Promise((resolve, reject) => {
    const authDetails = new AuthenticationDetails({
      Username: email,
      Password: password,
    });
    const user = new CognitoUser({ Username: email, Pool: userPool });

    user.authenticateUser(authDetails, {
      onSuccess: (result) => {
        const token = result.getIdToken().getJwtToken();
        resolve({ token, user });
      },
      onFailure: (err) => reject(err),
    });
  });

const signOut = () => {
  const user = userPool.getCurrentUser();
  if (user) user.signOut();
};

const getSession = () =>
  new Promise((resolve, reject) => {
    const user = userPool.getCurrentUser();
    if (!user) return reject("No user");

    user.getSession((err, session) => {
      if (err) return reject(err);
      resolve(session);
    });
  });

const confirmSignUp = (email, code) =>
  new Promise((resolve, reject) => {
    const user = new CognitoUser({ Username: email, Pool: userPool });
    user.confirmRegistration(code, true, (err, result) => {
      if (err) return reject(err);
      resolve(result);
    });
  });

export default {
  signUp,
  signIn,
  signOut,
  getSession,
  confirmSignUp
};
