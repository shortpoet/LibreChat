/**
 * Welcome to Cloudflare Workers! This is your first worker.
 *
 * - Run `npm run dev` in your terminal to start a development server
 * - Open a browser tab at http://localhost:8787/ to see your worker in action
 * - Run `npm run deploy` to publish your worker
 *
 * Learn more at https://developers.cloudflare.com/workers/
 */

import { ExecutionContext } from '@cloudflare/workers-types';
import handleProxy from './proxy';
import handleRedirect from './redirect';
import apiRouter from './router';
import { MethodNotAllowedError, NotFoundError } from '@cloudflare/kv-asset-handler/dist/types';

export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    try {
      logWorkerStart(request);
      return await handleFetchEvent(request, env, ctx);
    } catch (e) {
      console.error(e);
      if (e instanceof NotFoundError) {
        return new Response('Not Found', { status: 404 });
      } else if (e instanceof MethodNotAllowedError) {
        return new Response('Method Not Allowed', { status: 405 });
      } else {
        return new Response(JSON.stringify(e), { status: 500 });
      }
    }
  },
};

async function handleFetchEvent(
  request: Request,
  env: Env,
  ctx: ExecutionContext,
): Promise<Response> {
  const url = new URL(request.url);
  const path = url.pathname;

  // You can get pretty far with simple logic like if/switch-statements
  switch (url.pathname) {
    case '/redirect':
      return handleRedirect.fetch(request, env, ctx);

    case '/proxy':
      return handleProxy.fetch(request, env, ctx);
  }

  if (url.pathname.startsWith('/api/')) {
    // You can also use more robust routing
    return apiRouter.handle(request);
  }

  return new Response(
    `Try making requests to:
    <ul>
    <li><code><a href="/redirect?redirectUrl=https://example.com/">/redirect?redirectUrl=https://example.com/</a></code>,</li>
    <li><code><a href="/proxy?modify&proxyUrl=https://example.com/">/proxy?modify&proxyUrl=https://example.com/</a></code>, or</li>
    <li><code><a href="/api/todos">/api/todos</a></code></li>`,
    { headers: { 'Content-Type': 'text/html' } },
  );
}
