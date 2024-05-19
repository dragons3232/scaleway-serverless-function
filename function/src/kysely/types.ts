import type { ColumnType } from "kysely";
export type Generated<T> = T extends ColumnType<infer S, infer I, infer U>
  ? ColumnType<S, I | undefined, U>
  : ColumnType<T, T | undefined, T>;
export type Timestamp = ColumnType<Date, Date | string, Date | string>;

export type Log = {
    id: Generated<number>;
    createdAt: Generated<Timestamp>;
    message: string;
};
export type DB = {
    Log: Log;
};
