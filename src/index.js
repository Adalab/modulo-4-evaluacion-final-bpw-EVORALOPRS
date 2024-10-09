const express = require('express');
const cors = require('cors');
const mysql = require('mysql2/promise');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

require('dotenv').config();

const server = express();
server.use(cors());
server.use(express.json({limit:"100mb"}));

const PORT = process.env.PORT || 3000;
server.listen(PORT,()=>{
    console.log(`Server listening at http://localhost:${PORT}`);
});

async function connectDB(){
    const conex = await mysql.createConnection({
        host: process.env.HOST,
        user: process.env.DB_USER,
        password:process.env.DB_PASSWORD,
        database: process.env.DB_DATABASE
    });
    await conex.connect();
    //console.log(conex);
    return conex;
};

//peticion del listado de libros
server.get("/allbooks", async (req,res)=>{
   
        const conex = await connectDB();
        const sql = 'SELECT * FROM book';
        const [resultBook] = await conex.query(sql);
        
        conex.end()
        res.status(200).json({
            success: true,
            result: resultBook
        });   
});

// petion del listado de los autores
server.get("/allauthors", async(req, res)=>{

    const conex = await connectDB();
    const sql = 'SELECT * FROM author';
    const [resultAuthor] = await conex.query(sql);

    conex.end()
    res.status(200).json({
        success:true,
        result:resultAuthor
    })
})

// peticion del nombre del author y cuantos libros tiene
server.get("/books/author/:name", async (req, res)=>{
    //tengo que obtener el nombvre del autor con los parametros 
    const authorName = req.params.name 

    const conex = await connectDB();
    const sql = 'SELECT * FROM book JOIN author ON book.id_author = author.id_author WHERE author.name = ?';
    const [resultBookByAuthor] = await conex.query(sql,[authorName]);
    conex.end();
   
   if(resultBookByAuthor.length === 0){
    return res.status(404).json({
        success: false,
        message: "No hay libro con este author"
    })
   }
   res.json(resultBookByAuthor);

})

//eliminar un libro
server.delete("/books/:id", async (req,res)=>{
    const id = req.params.id;
    const conex = await connectDB();
    const sql = 'DELETE FROM book WHERE id=?'
    const [resultDeleteBook] = await conex.query(sql[id]);
     
    if(resultDeleteBook.affectedRows >0 ){
        res.status(200).json({
            success:true,
            message: 'Libro eliminado'
        });
    }else{
        res.status(404).json({
            success:false,
            message: 'Libro no encontrado'
        });
    }
});

//Añadir un nuevo libro
server.post("/addnewbook", async (req,res)=>{
    const {title, date_public, gender, sypnosis} = req.body;
    if(!title || !date_public || !gender || !sypnosis){
        res.status(404).json({
            success:false,
            message: 'Es obligatorio rellenar todos los campos'
        });
    }else{
        const conex = await connectDB();
        const sql = 'INSERT INTO book (title, date_public, gender,sypnosis) values(?,?,?,?)'
        const [resultAddNewBook] = await conex.query(sql, [title,date_public,gender,sypnosis]);
        res.status(200).json({
            success:true,
            id: resultAddNewBook.insertId,
        });
    }

});

server.post("/server/login", async (req,res)=>{
    const conex = await getDBConnection();
    const {email, password} =req.body;
    const emailQuery = 'SELECT * FROM users WHERE email = ?';
    const [userResult] = await conex.query(emailQuery,[email]);
    if(userResult.length > 0){
      //valido si la contraseña del usuario coincide con la que está guardado en la base de datos
      const isSamePassword = await bcrypt.compare(password,userResult[0].hashed_password);
      if(isSamePassword){
        //info para guardar los datos en el token
        const infoToken ={
          id: userResult[0].id,
          email:userResult[0].email,
        };
        //generar el token con JWT, cuando hacemos login 
        const token = jwt.sign(infoToken, "clave_secreta", {expiresIn: "1h"});
        res.status(200).json({success:true, toke:token})
      }else{
        res.status(403).json({success:false, message:"Contraseña incorrecta"});
      }
    } else{
      res.status(404).json({success:false, message: "Usuario no está registrado.Email no existe" })
    }
  });




// registro de usuario
server.post("/server/register", async (req, res)=>{
    const{name, email, password} = req.body;
    const conex = await connectDB();
    const sql = 'SELECT * FROM users WHERE email = ?'
    const [resultNewUser] = await conex.query(sql,[email])

    if(resultNewUser === 0){
        const passHashed = await bcrypt.hash(password,10)
        const sqlInsert = 'INSERT INTO users (name, email,hashes_password) value(?,?,?)';
        const [resultUser] = await conex.query(sqlInsert,[name,email,passHashed]);
        res.status(201).json({success: true, result: resultUser.insertId})
    }else{
      res.status(200).json({success: false, result: "El email ya existe"})
    }
  conex.end(); 
    });