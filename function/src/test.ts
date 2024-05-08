import dotenv from 'dotenv';
import path from 'path';

dotenv.config({ path: path.resolve('.', '.env') });

import { handle } from './handler/hello';

handle(
  {
    body: {
      name: 'Tester',
      message: 'Hello World!'
    }
  },
  { functionName: 'say-hello' },
  console.log
)