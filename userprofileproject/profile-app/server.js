const express = require("express");
const mongoose = require("mongoose");
const redis = require("redis");

const app = express();

app.use(express.json());
app.use(express.static("public"));

mongoose.connect(
  "mongodb://admin:root123@mongo:27017/userdb?authSource=admin"
)
.then(() => console.log("MongoDB connected"))
.catch(err => console.log(err));

const User = mongoose.model("User", {
  name: String,
  email: String,
  designation: String
});
/* Redis connection */
const redisClient = redis.createClient({
  url: "redis://redis:6379"
});

redisClient.connect();

redisClient.on("connect", () => {
  console.log("Redis connected");
});

app.post("/user", async (req, res) => {

  const savedUser = await User.create(req.body);

  res.json({
    success: true,
    message: "User saved successfully",
    data: savedUser
  });

});

/* GET USERS with Redis cache */
app.get("/users", async (req, res) => {

  try {

    /* 1. Check cache */
    const cachedUsers = await redisClient.get("users");

    if (cachedUsers) {

      console.log("Cache HIT");

      return res.json(JSON.parse(cachedUsers));

    }

    /* 2. If not in cache, fetch from MongoDB */
    console.log("Cache MISS");

    const users = await User.find();

    /* 3. Store in Redis for 60 seconds */
    await redisClient.setEx(
      "users",
      60,
      JSON.stringify(users)
    );

    res.json(users);

  } catch (err) {

    console.error(err);

    res.status(500).send("Error");

  }

});

app.listen(3000, "0.0.0.0", () =>
  console.log("Server running")
);