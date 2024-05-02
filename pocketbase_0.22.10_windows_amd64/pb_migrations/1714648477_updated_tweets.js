/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("bj3affgxky3y84v")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "qpphcjxz",
    "name": "text",
    "type": "text",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "min": null,
      "max": null,
      "pattern": ""
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("bj3affgxky3y84v")

  // remove
  collection.schema.removeField("qpphcjxz")

  return dao.saveCollection(collection)
})
