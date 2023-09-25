const express=require('express');
const User=require("./models/user");
const authRouter=express.Router();


authRouter.post('/api/signup',async (req,res)=>{
const { name, email, password}= req.body;


const exitUser=await  User.findOne({email, });
if(exitUser){
    return res.status(400).json({mes:"same user with this email address is alredy exits"});
}
let user=new User({ 
    email,password,name,

})
user=await  user.save();
res.json(user);
});

module.exports=authRouter;  