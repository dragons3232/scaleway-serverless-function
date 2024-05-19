import { db } from '../kysely/database';

export const handle = async (event: any, context: any, callback: Function) => {
  console.log(event, context)

  const { body } = event;
  const { name, message } = typeof body === 'string' ? JSON.parse(body) : body;

  await db.insertInto('Log')
    .values({
      message: Math.random().toString(36).substring(7),
    })
    .executeTakeFirst()

  const logs = await db.selectFrom('Log')
    .selectAll()
    .execute()
  console.log("🚀 ~ handle ~ logs:", logs)

  return respond(true, `${message}, ${name}`);
}

const respond = (success: boolean, message?: any) => {
  return {
    statusCode: 200,
    body: JSON.stringify({
      source: "Test hello function",
      status: success ? "success" : "failed",
      message,
    }),
    headers: {
      "Content-Type": "application/json",
    },
  }
}

export default handle