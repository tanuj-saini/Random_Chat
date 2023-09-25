const mongoose=require('mongoose');
const authRouter = require('./routes/auth');
const userSchema=mongoose.Schema({
    name:{
        required :true,trim:true,
        type:String,

    },
    email:{
        required :true,
        type:String,
        trim:true,
        validate:{
            validate:(value)=>{
                const re =
                /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
               return value.match(re);

       
            },
            message:"Please enter a valid email address",
        }
    },
    password:{
        required :true,
        type:String,
        validate:{
            validate:(value)=>{
               return value.length>6;

       
            },
            message:"Please enter a 6 digit long password",
        }

    },
    address:{
        type:String,
        default:"",

    },
    type:{type:String,
        default:'user',


    }


});
const User=mongoose.model("User",userSchema);
module.exports=User;
