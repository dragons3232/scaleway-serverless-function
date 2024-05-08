
export const handle = async (event: any, context: any, callback: Function) => {
  console.log(event, context)

  const { body } = event;
  const { name, message } = typeof body === 'string' ? JSON.parse(body) : body;
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