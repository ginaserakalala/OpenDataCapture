import { $BooleanString } from '@opendatacapture/schemas/core';
import { z } from 'zod';

const $OptionalURL = z.preprocess(
  (arg) => arg || undefined,
  z
    .string()
    .url()
    .optional()
    .transform((arg) => (arg ? new URL(arg) : undefined))
);

export const $Configuration = z
  .object({
    API_DEV_SERVER_PORT: z.coerce.number().positive().int().optional(),
    API_PROD_SERVER_PORT: z.coerce.number().positive().int().default(80),
    DANGEROUSLY_DISABLE_PBKDF2_ITERATION: $BooleanString.default(false),
    DEBUG: $BooleanString,
    GATEWAY_API_KEY: z.string().min(32),
    GATEWAY_DEV_SERVER_PORT: z.coerce.number().positive().int().optional(),
    GATEWAY_ENABLED: $BooleanString,
    GATEWAY_INTERNAL_NETWORK_URL: $OptionalURL,
    GATEWAY_REFRESH_INTERVAL: z.coerce.number().positive().int(),
    GATEWAY_SITE_ADDRESS: $OptionalURL,
    POSTGRES_HOST: z.string(),
    POSTGRES_PORT: z.coerce.number().positive().int(),
    POSTGRES_USER: z.string(),
    POSTGRES_PASSWORD: z.string(),
    POSTGRES_DB: z.string(),
    NODE_ENV: z.enum(['development', 'production', 'test']),
    SECRET_KEY: z.string().min(32),
    THROTTLER_ENABLED: $BooleanString.default(true),
    VERBOSE: $BooleanString
  })
  .superRefine((env, ctx) => {
    if (env.NODE_ENV === 'production') {
      if (!env.GATEWAY_SITE_ADDRESS) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          message: 'GATEWAY_SITE_ADDRESS must be defined in production'
        });
      }
    } else if (env.NODE_ENV === 'development') {
      if (!env.API_DEV_SERVER_PORT) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          message: 'API_DEV_SERVER_PORT must be defined in development'
        });
      }
      if (!env.GATEWAY_DEV_SERVER_PORT) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          message: 'GATEWAY_DEV_SERVER_PORT must be defined in development'
        });
      }
    }
    // Additional validation for PostgreSQL configuration can be added if needed
  });

export type Configuration = z.infer<typeof $Configuration>;
