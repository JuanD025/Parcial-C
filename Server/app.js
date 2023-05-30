const express = require("express");
const mongoose = require("mongoose");
const path = require("path");
const bodyParser = require("body-parser");
const cors = require("cors");

const uri =
  "mongodb+srv://Juan:juan4880280@cluster0.3i1sqto.mongodb.net/CruRio?retryWrites=true&w=majority";
mongoose
  .connect(uri, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => {
    console.log("Conectado");
  })
  .catch((e) => {
    console.log("Error: " + e);
  });

const app = express();

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

const videoDir = path.join(__dirname, "/uploads");
const files = ["cascada.mp4", "leon.mp4", "narcisos.mp4", "oceano.mp4"];

app.get("/video", function (req, res) {
  const randomIndex = Math.floor(Math.random() * files.length);
  const randomFileName = files[randomIndex];
  const videoPath = path.join(videoDir, randomFileName);
  res.sendFile(videoPath);
});

app.get("/users", async (req, res) => {
  try {
    const collection = mongoose.connection.collection("puntajes");
    const users = await collection
      .find()
      .sort({ puntaje: 1, time: 1}) 
      .limit(10) 
      .toArray();
    console.log("Echo");
    res.json(users);
  } catch (e) {
    console.error(e);
    res.status(500).send("Error al obtener los usuarios");
  }
});

const PuntajeSchema = new mongoose.Schema({
  nombre: String,
  puntaje: Number,
  time: Number,
});

const Puntaje = mongoose.model("puntajes", PuntajeSchema);

app.post("/users", async (req, res) => {
  try {
    const nombre = req.body.nombre;
    const puntaje = req.body.puntaje;
    const time = req.body.time;
    const puntajeObjeto = new Puntaje({ nombre, puntaje, time });
    await puntajeObjeto.save();
    res.send("Datos insertados correctamente");
  } catch (e) {
    console.error(e);
    res.status(500).send("Error al insertar los datos");
  }
});

app.listen(3000, () => {
  console.log("Servidor escuchando en el puerto 3000");
});
