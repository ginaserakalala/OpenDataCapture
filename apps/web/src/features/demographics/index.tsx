/* eslint-disable perfectionist/sort-objects */

import type { RouteObject } from 'react-router-dom';

import { DemographicsPage } from './pages/DemographicsPage';

export const demographicsRoute: RouteObject = {
  path: 'demographics',
  element: <DemographicsPage />
};
