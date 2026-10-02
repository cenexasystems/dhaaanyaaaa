import { neon, type NeonQueryFunction } from '@neondatabase/serverless';

export const sql: NeonQueryFunction<false, false> = (() => {
  const connectionString = process.env.DATABASE_URL;
  if (connectionString) return neon(connectionString);

  // Build-time safe (pages can still prerender), but any real query throws a
  // descriptive error instead of failing against a bogus connection string.
  console.warn('DATABASE_URL is not set. Database queries will fail until it is configured.');
  const fail = () => {
    throw new Error(
      'DATABASE_URL is not configured. Add it to .env.local (local) or the deployment platform environment variables.'
    );
  };
  return fail as unknown as NeonQueryFunction<false, false>;
})();
