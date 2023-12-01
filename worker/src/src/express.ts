// import { resolve } from "path";
// import parseurl from "parseurl";
// import slackNotify from "./slack-notify";

// export class ExpressRequest {
//   constructor({ path, method, url, headers, body }) {
//     this.path = path;
//     this.method = method;
//     this.url = url;
//     this.headers = headers;
//     this.body = body;
//     this.params = this.path.split("/").filter((x) => x);
//     const { host, protocol } = parseurl(this);
//     this.headers.host = host;
//     this.protocol = protocol.slice(0, protocol.length - 1);
//   }

//   get(headerName) {
//     return this.headers[headerName];
//   }
// }

// export class ExpressResponse {
//   constructor({ resolve, reject }) {
//     this._resolve = resolve;
//     this._reject = reject;
//     this._status = 200;
//     this._headers = {};
//   }

//   status(code) {
//     this._status = code;
//   }

//   json(obj) {
//     const str = JSON.stringify(obj, null, 2);
//     this.header("content-type", "application/json");
//     return this.send(str);
//   }

//   send(data) {
//     if (data !== null && typeof data === "object") {
//       return this.json(data);
//     }
//     if (data === null || data === undefined) {
//       data = "";
//     }
//     if (typeof data !== "string") {
//       throw new Error("can't handle data type " + typeof data);
//     }
//     if (this._status === 500) {
//       slackNotify(
//         JSON.stringify({
//           status: 500,
//           data,
//         })
//       );
//     }
//     this.sendResponse(
//       new Response(data, {
//         status: this._status,
//         headers: {
//           ...this._headers,
//         },
//       })
//     );
//   }

//   end() {
//     this.send();
//   }

//   // worker-specific one if we want to manage Response ourselves
//   sendResponse(workerResponse) {
//     this._resolve(workerResponse);
//   }

//   header(field, value) {
//     this._headers[field] = value;
//   }

//   set(...args) {
//     return this.header(...args);
//   }

//   sendStatus(code) {
//     this.status(code);
//     if (code === 204) {
//       return this.send("");
//     }
//     this.send(`${this._status}`);
//   }
// }

// export class ExpressApp {
//   constructor() {}

//   use(fn) {
//     this.router = fn;
//   }

//   listen() {
//     // port is ignored, we're a service worker

//     addEventListener("fetch", (event) => {
//       event.respondWith(this._handleRequest(event.request));
//     });
//   }

//   async _handleRequest(workerReq) {
//     let body;
//     if (workerReq.method === "POST") {
//       try {
//         body = await workerReq.json();
//       } catch (e) {
//         return new Response(e.message, {
//           status: 500,
//           headers: {
//             "content-type": "text/plain",
//           },
//         });
//       }
//     }
//     return new Promise((resolve, reject) => {
//       const path = new URL(workerReq.url).pathname;
//       const req = new ExpressRequest({
//         path,
//         method: workerReq.method,
//         url: workerReq.url,
//         headers: workerReq.headers,
//         body: body,
//       });
//       const res = new ExpressResponse({ resolve, reject });
//       if (!this.router) {
//         return reject(new Error("no route found"));
//       }
//       this.router(req, res, (err) => {
//         if (err) {
//           return reject(err);
//         }
//         reject(new Error("request got past the router"));
//       });
//     }).catch((err) => {
//       if (!err) {
//         err = new Error("undefined error");
//       }
//       return new Response([err.message, err.stack].join("\n"), {
//         status: 500,
//         headers: {
//           "content-type": "text/plain",
//         },
//       });
//     });
//   }
// }

// export default function (...args) {
//   return new ExpressApp(...args);
// }
