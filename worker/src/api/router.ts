import {
  // Router,
  createCors,
  RequestLike,
  IRequest,
  error,
} from 'itty-router';
import { OpenAPIRouter } from '@cloudflare/itty-router-openapi';

import { jsonData, withCfHeaders, withCfSummary } from '../middleware';

import data from './data.json';

const { preflight, corsify } = createCors();

// export { preflight, corsify };

type CF = [env: Env, context: ExecutionContext];

const router = OpenAPIRouter<IRequest, CF>({
  schema: {
    info: {
      title: 'Ai Maps API',
      version: '1.0',
    },
  },
  base: '/',
  docs_url: '/api/docs',
  openapi_url: '/api/openapi.json',
});

const protectedRoutes = {
  '/api/health/debug': { route: '/api/health/debug', isAdmin: true },
};

router
  .options('*', preflight)
  .all('/api/*', withCfHeaders())
  // .all('/api/*', () => {})
  .get('/api/json-data', (req: IRequest, res: Response, env: Env, ctx: ExecutionContext) =>
    jsonData(req, res, env, data),
  )
  .get(
    '/api/hello',
    withCfSummary(),
    (req: IRequest, res: Response, env: Env, ctx: ExecutionContext) =>
      jsonData(req, res, env, { hello: 'world' }),
  )
  // .all("*", error_handler)
  .all('*', () => error(404, 'Oops... Are you sure about that? FAaFO'));

export default router;
