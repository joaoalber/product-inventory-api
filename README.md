# Product Inventory API

## Introduction

This document provides the instructions to run the project as well as understand it properly

---

## Configuration

## Project

Install Ruby 3.1.0 (you can use RVM or asdf):
- https://rvm.io/
- https://github.com/asdf-vm/asdf

After Ruby install, open bash and install Rails 7.0.2.2: 

```
gem install rails --version 7.0.2.2
```

Setup the project with the command:

```
bundle install
```

## Database

You can use [Docker](https://www.docker.com/) to run Postgres on your machine without any plus configuration

PS: It's important to use this values for user and password to match the config/database.yml file

```
docker run --name postgsql -e "POSTGRES_USER=root" -e "POSTGRES_PASSWORD=development" -p 5432:5432 -d postgres
```

Create the databases:

```
bundle exec rails db:create
```

Run database migrations:

```
bundle exec rails db:migrate
```

Run web server:
```
bundle exec rails s
```

Then, you can do API requests properly

---

## Product Quantity History

Gem used: https://github.com/paper-trail-gem/paper_trail

If you have a product and you update the quantity of it, the application will create a entry on versions database to show the changes during this update, example:

```
3.1.0 :002 > product.update(quantity: 3)
=> true

3.1.0 :003 > product.versions
=> [#<PaperTrail::Version:0x00007fc96e69eb48 ...] 
```

---

## GraphQL Requests

You can use any HTTP implementer to do the requests, I recommend to use [Postman Desktop](https://www.postman.com/) (for localhost purposes)

**PS: All requests had to be done on /graphql using POST HTTP verb, example:**

```
POST localhost:3000/graphql
```

---

## Create a Product

Creates a product on database

**Params:**

- **required** - name (String): product's name
- **optional** - description (String): product's description
- **required** - archived (Boolean): if product is archived or no
- **required** - price (Float): product's price 
- **required** - quantity (Integer): product's quantity
- **required** - categories ([String]): product's categories

**Body Example:**

```
mutation {
  createProductMutation(input: {
    name: "Product",
    description: "Beauty Product",
    archived: false,
    price: 10.0,
    quantity: 1,
    categories: ["Beautiful", "Amazing"]
  }) {
    product {
      archived
      categories
      description
      name
      price
    }
  }
}
```

**Response Example:**

```
{
  "data": {
    "createProductMutation": {
      "product": {
        "archived": false,
        "categories": [
            "Beautiful",
            "Amazing"
        ],
        "description": "Beauty Product",
        "name": "Product",
        "price": 10.0
      }
    }
  }
}
```

---

## Update a Product

Updates an existing product on database

If the product was not in the database, GraphQL will return an error

**Params:**

- **required** - id (Integer): product's id
- **optional** - name (String): product's name
- **optional** - description (String): product's description
- **optional** - archived (Boolean): if product is archived or no
- **optional** - price (Float): product's price 
- **optional** - quantity (Integer): product's quantity
- **optional** - categories ([String]): product's categories

**Body Example:**

```
mutation {
  updateProductMutation(input: {
    id: 1,
    description: "Updated product",
    archived: false,
    price: 10.50,
    quantity: 1,
    categories: ["Closet"]
  }) {
    product {
      archived
      categories
      description
      name
      price
    }
  }
```

**Response Example:**

```
{
  "data": {
    "updateProductMutation": {
      "product": {
        "archived": false,
        "categories": ["Closet"],
        "description": "Updated product",
        "name": "Product",
        "price": 10.5
      }
    }
  }
}
```

---

## Delete a Product

Deletes an existing product

If the product was not in the database, GraphQL will return an error

**Params:**

- **required** - id (Integer): product's id

**Body Example:**

```
mutation {
  deleteProductMutation(input: {
    id: 1
  }) {
    product {
      name
      id
    }
  }
}
```

**Response Example:**

```
{
  "data": {
    "deleteProductMutation": {
      "product": {
        "name": "Hotwheels Car",
        "id": "1"
      }
    }
  }
}
```

---

## Bulk Update Product

Updates existing products

If the product one of the product was not in the database, GraphQL will return an error and database will rollback the other product's update transaction

**Params:**

- **required** - products ([Product]): product's to be update

Product Array:

- **required** - id (Integer): product's id
- **optional** - name (String): product's name
- **optional** - description (String): product's description
- **optional** - archived (Boolean): if product is archived or no
- **optional** - price (Float): product's price 
- **optional** - quantity (Integer): product's quantity
- **optional** - categories ([String]): product's categories

**Body Example:**

```
mutation {
  bulkUpdateProductMutation(input: {
    products: [
      {
        id: 1,
        name: "product_updated"
      },
      {
        id: 2,
        name: "product_updated_2"
      }
    ]
  }) {
    updated
  }
}
```

**Response Example:**

```
{
  "data": {
    "bulkUpdateProductMutation": {
      "updated": true
    }
  }
}
```

---

## Show a Product

Shows an existing product

If the product was not in the database, GraphQL will return an error

**Params:**

- **required** - id (Integer): product's id

**Body Example:**

```
query {
  showProductQuery(id: 5) {
    id
    archived
    description
    name
  }
}
```

**Response Example:**

```
{
  "data": {
    "showProductQuery": {
      "id": "5",
      "archived": false,
      "description": null,
      "name": "Superman Toy"
    }
  }
}
```

---

## List Products

List existings products based on filters

**Params:**

- **optional** - archived (Boolean): if product is archived or no
- **optional** - price (Float): product's price 
- **optional** - categories ([String]): product's categories

PS: Filter on price field will return the product that has the price GREATER THAN the value

If you don't pass any filter, the query will list all existing products

**Body Example:**

```
query {
  listProductQuery(
    categories: ["Amazing"], archived: true, price: 10.0
  ) {
    id
    archived
    description
    name
  }
}
```

**Response Example:**

```
{
  "data": {
    "listProductQuery": [
      {
        "price": 12.0,
        "id": "6",
        "archived": true,
        "description": "Product example",
        "name": "Calça",
        "categories": [
          "Amazing",
          "For Kids"
        ]
      },
      {
        "price": 11.0,
        "id": "5",
        "archived": true,
        "description": null,
        "name": "product_updated",
        "categories": ["Amazing"]
      },
      {
        "price": 11.5,
        "id": "4",
        "archived": true,
        "description": null,
        "name": "product_updated_2",
        "categories": [
          "Amazing",
          "Colorful"
        ]
      }
    ]
  }
}
```
