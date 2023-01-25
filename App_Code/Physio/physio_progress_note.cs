using System;
using System.Collections.Generic;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;

 
 public class physio_progress_note  
 {  
 public physio_progress_note()  
 {  
     objCon = Util.GetMySqlCon();  
     this.IsLocalConn = true;  
 }  
 public physio_progress_note(MySqlTransaction objTrans)  
 {  
 this.objTrans = objTrans;  
 this.IsLocalConn = false;  
 }  
   
     #region All Memory Variables  
       
     private int  _ID;  
     private string  _TransactionID;  
     private string  _PatientID;
     private string _S_Pain_Level;  
     private string  _S_Type;
     private string _S_Type_Other;
     private string  _S_Location;  
     private string  _S_Patient;
     private string _S_Patient_Text;
     private string  _O_Home;  
     private int  _O_See;  
     private string  _O_Tool;  
     private string  _O_Score;  
     private string  _O_Comments;  
     private string  _A_Progressing;  
     private string  _A_Limitation;  
     private string  _A_Improved;  
     private string  _P_Continue;  

     private int  _P_Comments;  
     private string  _P_Text;
     private string _O_Treatment;
     private string  _EntryBy;  
     private DateTime  _Entrydate;
     private string _Other_treatment;
     
     #endregion  
   
     #region All Global Variables  
   
     MySqlConnection objCon;  
     MySqlTransaction objTrans;  
     bool IsLocalConn;  
   
     #endregion  
     #region Set All Property  
     public virtual int ID { get { return _ID; } set { _ID = value; } }  
     public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }  
     public virtual string PatientID { get { return _PatientID; } set { _PatientID = value; } }
     public virtual string S_Pain_Level { get { return _S_Pain_Level; } set { _S_Pain_Level = value; } }  
     public virtual string S_Type { get { return _S_Type; } set { _S_Type = value; } }
     public virtual string S_Type_Other { get { return _S_Type_Other; } set { _S_Type_Other = value; } }
     public virtual string S_Location { get { return _S_Location; } set { _S_Location = value; } }  
     public virtual string S_Patient { get { return _S_Patient; } set { _S_Patient = value; } }
     public virtual string S_Patient_Text { get { return _S_Patient_Text; } set { _S_Patient_Text = value; } } 
     public virtual string O_Home { get { return _O_Home; } set { _O_Home = value; } }  
     public virtual int O_See { get { return _O_See; } set { _O_See = value; } }  
     public virtual string O_Tool { get { return _O_Tool; } set { _O_Tool = value; } }  
     public virtual string O_Score { get { return _O_Score; } set { _O_Score = value; } }  
     public virtual string O_Comments { get { return _O_Comments; } set { _O_Comments = value; } }  
     public virtual string A_Progressing { get { return _A_Progressing; } set { _A_Progressing = value; } }  
     public virtual string A_Limitation { get { return _A_Limitation; } set { _A_Limitation = value; } }  
     public virtual string A_Improved { get { return _A_Improved; } set { _A_Improved = value; } }
     public virtual string P_Continue { get { return _P_Continue; } set { _P_Continue = value; } }  

     public virtual int P_Comments { get { return _P_Comments; } set { _P_Comments = value; } }  
     public virtual string P_Text { get { return _P_Text; } set { _P_Text = value; } } 
      public virtual string O_Treatment { get { return _O_Treatment; } set { _O_Treatment = value; } } 
     public virtual string EntryBy { get { return _EntryBy; } set { _EntryBy = value; } }  
     public virtual DateTime Entrydate { get { return _Entrydate; } set { _Entrydate = value; } }
     public virtual string Other_treatment { get { return _Other_treatment; } set { _Other_treatment = value; } } 
     #endregion  
   
     #region All Public Member Function  
  public string Insert()   
       {   
           int Output =0;   
           try   
           {   
               StringBuilder objSQL = new StringBuilder();   
     
               objSQL.Append("physio_progress_note_insert");   
     
               if (IsLocalConn)   
               {   
                   this.objCon.Open();   
                   this.objTrans = this.objCon.BeginTransaction();   
               }   
     
     
               MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);   
               cmd.CommandType = CommandType.StoredProcedure;   
     
               cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));   
               cmd.Parameters.Add(new MySqlParameter("@vPatientID", Util.GetString(PatientID)));
               cmd.Parameters.Add(new MySqlParameter("@vS_Pain_Level", Util.GetString(S_Pain_Level)));   
               cmd.Parameters.Add(new MySqlParameter("@vS_Type", Util.GetString(S_Type)));
               cmd.Parameters.Add(new MySqlParameter("@vS_Type_Other", Util.GetString(S_Type_Other)));
               cmd.Parameters.Add(new MySqlParameter("@vS_Location", Util.GetString(S_Location)));   
               cmd.Parameters.Add(new MySqlParameter("@vS_Patient", Util.GetString(S_Patient)));
               cmd.Parameters.Add(new MySqlParameter("@vS_Patient_Text", Util.GetString(S_Patient_Text)));
               cmd.Parameters.Add(new MySqlParameter("@vO_Home", Util.GetString(O_Home)));   
               cmd.Parameters.Add(new MySqlParameter("@vO_See", Util.GetInt(O_See)));   
               cmd.Parameters.Add(new MySqlParameter("@vO_Tool", Util.GetString(O_Tool)));   
               cmd.Parameters.Add(new MySqlParameter("@vO_Score", Util.GetString(O_Score)));   
               cmd.Parameters.Add(new MySqlParameter("@vO_Comments", Util.GetString(O_Comments)));   
               cmd.Parameters.Add(new MySqlParameter("@vA_Progressing", Util.GetString(A_Progressing)));   
               cmd.Parameters.Add(new MySqlParameter("@vA_Limitation", Util.GetString(A_Limitation)));   
               cmd.Parameters.Add(new MySqlParameter("@vA_Improved", Util.GetString(A_Improved)));
               cmd.Parameters.Add(new MySqlParameter("@vP_Continue", Util.GetString(P_Continue)));   
               
               cmd.Parameters.Add(new MySqlParameter("@vP_Comments", Util.GetInt(P_Comments)));   
               cmd.Parameters.Add(new MySqlParameter("@vP_Text", Util.GetString(P_Text)));
               cmd.Parameters.Add(new MySqlParameter("@vO_Treatment", Util.GetString(O_Treatment)));   
               
               cmd.Parameters.Add(new MySqlParameter("@vEntryBy", Util.GetString(EntryBy)));   
               cmd.Parameters.Add(new MySqlParameter("@vEntrydate", Util.GetDateTime(Entrydate)));
               cmd.Parameters.Add(new MySqlParameter("@vOther_treatment", Util.GetString(Other_treatment)));
               Output = Util.GetInt(cmd.ExecuteScalar());
     
               if (IsLocalConn)   
               {   
                   this.objTrans.Commit();   
                   this.objCon.Close();   
               }   
     
               return Output.ToString();   
           }   
           catch (Exception ex)   
           {   
               if (IsLocalConn)   
               {   
                   if (objTrans != null) this.objTrans.Rollback();   
                   if (objCon.State == ConnectionState.Open) objCon.Close();   
               }   
               // Util.WriteLog(ex);   
               throw (ex);   
           }   
       }   

   

   

     #endregion 
   
 }  