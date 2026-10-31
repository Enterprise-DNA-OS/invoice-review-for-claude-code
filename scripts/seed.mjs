import fs from "node:fs";
import path from "node:path";
import { pathToFileURL } from "node:url";
import { getDb, REPO_ROOT } from "./lib/db.mjs";
export async function seed(db) {
  if (Number((await db.query("select count(*) n from events"))[0].n) > 0)
    throw Error("Refusing demo seed after operational changes");
  if (
    (
      await db.query(
        "select count(*) n from invoices where code not like 'INV-10%'",
      )
    )[0].n > 0
  )
    throw Error("Refusing demo seed over business records");
  await db.exec(
    fs.readFileSync(path.join(REPO_ROOT, "supabase/seed.sql"), "utf8"),
  );
}
if (import.meta.url === pathToFileURL(path.resolve(process.argv[1])).href) {
  if (process.env.DATABASE_URL) throw Error("Demo seed refuses DATABASE_URL");
  const db = await getDb();
  try {
    await seed(db);
    console.log("Fictional demo seeded");
  } finally {
    await db.close();
  }
}
