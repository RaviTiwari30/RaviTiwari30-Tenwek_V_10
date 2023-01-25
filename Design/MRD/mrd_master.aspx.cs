using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;
using System.Linq;
using MySql.Data.MySqlClient;

public partial class Design_MRD_MRD_Master : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindPatientType();
        }
    }

    private void bindPatientType()
    {
        DataTable dt = StockReports.GetDataTable("SELECT DISTINCT(pmh.TYPE)PType FROM patient_medical_history pmh ORDER BY TYPE");
        chkPatientType.DataSource = dt;
        chkPatientType.DataTextField = "PType";
        chkPatientType.DataValueField = "PType";
        chkPatientType.DataBind();
      
        
    }

    [WebMethod(EnableSession = true)]
    public static string savedocument(string documentName, string sequenceName, string patientType, string saveType,string IsActive,string documentID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try{
            var message="";

            string str = "SELECT COUNT(*) FROM mrd_document_master WHERE ( NAME='" + documentName + "' OR SequenceNo='" + sequenceName + "' ) AND CentreID=" + HttpContext.Current.Session["CentreID"] + "";
            if (documentID != "")
            {
                str += " AND  DocumentID <>" + documentID + "";
            }
            var IsExist = Util.GetInt(StockReports.ExecuteScalar(str));
            if (IsExist > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Document Name or Sequence No Already Exists" });
            }
            if (saveType == "Save")
            {
                var sqlCMD = "insert into mrd_document_master(NAME,EntDate,UserID,SequenceNo,IsActive,CentreID,IPAddress,patientType) values(@documentName,Now(),@UserID,@SequenceNo,@IsActive,@CentreID,@IPAddress,@patientType) ";

                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                    {
                        documentName = documentName,
                        UserID = HttpContext.Current.Session["ID"].ToString(),
                        SequenceNo = sequenceName,
                        CentreID = HttpContext.Current.Session["CentreID"].ToString(),
                        IPAddress = HttpContext.Current.Request.UserHostAddress,
                        patientType = patientType,
                        Isactive = IsActive,
                    });

                

                message = "Document Save Successfully";
                tnx.Commit();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message,Type="Save" });
            }
            else
            {
                var sqlCmd = " update mrd_document_master set NAME=@NAME,SequenceNo=@SequenceNo,patientType=@patientType,Isactive=@Isactive,IPAddress=@IPAddress,Updateby=@Updateby,UpdateDate=NOW() WHERE DocumentID=@DocumentID; ";
                excuteCMD.DML(tnx, sqlCmd, CommandType.Text, new
                {
                    NAME=documentName,
                    SequenceNo = sequenceName,
                    patientType=patientType,
                    Isactive=IsActive,
                    IPAddress=HttpContext.Current.Request.UserHostAddress,
                    Updateby=HttpContext.Current.Session["ID"].ToString(),
                    DocumentID = documentID,

                });
                message = "Document Update Successfully";
                tnx.Commit();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message, Type = "Update" });
            }
        }


        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string saveNewRoom(string roomName, string savetype, string isActive,string roomID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try {
            var message = "";
            string str = "select count(*) from mrd_room_master where name='" + roomName + "' and CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"]) + "";
            if (roomID != "")
            {
                str += " and RmID<>" + roomID + " ";
            }
            var IsExist = Util.GetInt(StockReports.ExecuteScalar(str));

            if (IsExist > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Room Name  Already Exist" });
            }
            if (savetype == "Save")
            {
                var sqlCmd = "insert into mrd_room_master (NAME,IsActive,EntDate,UserID,CentreID,IPAddress)values(@NAME,IsActive,NOW(),@UserID,@CentreID,@IPAddress)";

                excuteCMD.DML(tnx, sqlCmd, CommandType.Text, new
                {
                    NAME = roomName,
                    UserID = Util.GetString(HttpContext.Current.Session["ID"]),
                    CentreID = Util.GetString(HttpContext.Current.Session["CentreID"]),
                    IPAddress = Util.GetString(HttpContext.Current.Request.UserHostAddress),
                    IsActive = isActive,
                });
                message = "Room Save Successfully";
                tnx.Commit();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });
            }
            else {
                var sqlCmd = "update mrd_room_master set NAME=@NAME,IsActive=@IsActive,UpdateDate=NOW(),UpdateUserID=@UpdateUserID where RmID=@RmID and CentreID=@CentreID";

                excuteCMD.DML(tnx, sqlCmd, CommandType.Text, new {
                    NAME=roomName,
                    IsActive=isActive,
                    UpdateUserID=HttpContext.Current.Session["ID"].ToString(),
                    RmID=roomID,
                    CentreID=HttpContext.Current.Session["CentreID"],
                });
                message = "Room Update Successfully";
                tnx.Commit();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string bindDocumentlist()
    {
        DataTable dt = StockReports.GetDataTable(" SELECT DocumentID,NAME FROM mrd_document_master WHERE CentreID="+HttpContext.Current.Session["CentrEID"]+" ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);


    }
  
    [WebMethod (EnableSession=true)]

    public static string EditDcouementName(int documentID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT DocumentID,NAME,SequenceNo,patientType,IF(IsActive=1,'Yes','No')Active FROM mrd_document_master WHERE documentID=" + documentID + " AND CentreID=" + HttpContext.Current.Session["CentrEID"] + " ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string BindRoom()

    {
        DataTable dt = StockReports.GetDataTable(" SELECT NAME,RMID,(SELECT CONCAT(Title,' ',NAME) FROM employee_master WHERE EmployeeID =mrm.UserID )Createdby,DATE_FORMAT(EntDate,'%d-%b-%Y')CreatedDate,IF(IsActive=1,'Yes','No')Active,IF(IsActive=1,'1','0')IsActive FROM mrd_room_master mrm where centreID=" + HttpContext.Current.Session["CentreID"] + "; ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod(EnableSession = true)]
    public static string saveNewRack(string roomID, string rackName, string noOfShelf, string IsActive, string saveType,string noOfMaximumfile,string rackID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var message = "";
            string str = "SELECT COUNT(*) FROM mrd_almirah_master WHERE CentreID="+HttpContext.Current.Session["CentreID"]+" AND NAME='"+rackName+"'";
            if (roomID != "")
            {
                str += " AND  RmID <>" + roomID + "";
            }
            var IsExist = Util.GetInt(StockReports.ExecuteScalar(str));
            if (IsExist > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Rack Name is Already Exists" });
            }
            if (saveType == "Save")
            {
                var sqlCMD = "insert into mrd_almirah_master (Name,NoOfShelf,RmID,IsActive,UserID,IPADDRESS,CentreID,EntDate,MaximumNoofFiles) values(@Name,@NoOfShelf,@RmID,@IsActive,@UserID,@IPADDRESS,@CentreID,Now(),@MaximumNoofFiles)";

                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Name = rackName,
                    NoOfShelf = noOfShelf,
                    RmID = roomID,
                    IsActive = IsActive,
                    UserID = HttpContext.Current.Session["ID"].ToString(),
                    IPADDRESS = HttpContext.Current.Request.UserHostAddress,
                    CentreID = HttpContext.Current.Session["CentreID"],
                    MaximumNoofFiles=noOfMaximumfile,
                });

                string AmrID = Util.GetString( MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select AlmID from mrd_almirah_master where Name='" + rackName + "' AND CentreID=" + HttpContext.Current.Session["CentreID"] +" "));
                
                for (int i = 0; i < Util.GetInt(noOfShelf);i++ )
                {
                    string sqlLocationmaster = "insert into mrd_location_master (RmID, AlmID, ShelfNo, CurPos, MaxPos, AdditionalNo, IsActive, UserID,IPAddress,CentreID,EntDate ) values(@RmID,@AlmID,@ShelfNo,0,@MaxPos,0,@IsActive,@UserID,@IPAddress,@CentreID,NOW())";
                    excuteCMD.DML(tnx, sqlLocationmaster, CommandType.Text, new
                    {
                        RmID = roomID,
                        AlmID = AmrID,
                        ShelfNo = i + 1,
                        MaxPos = noOfMaximumfile,
                        IsActive = IsActive,
                        UserID = HttpContext.Current.Session["ID"].ToString(),
                        CentreID = HttpContext.Current.Session["CentreID"],
                        IPAddress = HttpContext.Current.Request.UserHostAddress,
                    });
                }
                message = "Rack Save Successfully";
                tnx.Commit();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message, Type = "Save" });

               
            }
            else {
                string Sqlcmd = " delete mlm.* from mrd_location_master mlm where RmID=@RmID and AlmID=@AlmID and CentreID=@CentreID";
                            excuteCMD.DML(tnx,Sqlcmd,CommandType.Text,new
                            {
                                RmID=roomID,
                                AlmID=rackID,
                                CentreID=HttpContext.Current.Session["CentreID"],
                            });

                            string Updaterackdetail = "update mrd_almirah_master set Name=@Name,NoOfShelf=@NoOfShelf,MaximumNoofFiles=@MaximumNoofFiles,UpdateID=@UpdateID,Updatedate=NOW() where AlmID=@AlmID and CentreID=@CentreID";
                                excuteCMD.DML(tnx,Updaterackdetail,CommandType.Text,new
                                {
                                        Name=rackName,
                                        NoOfShelf=noOfShelf,
                                        MaximumNoofFiles=noOfMaximumfile,
                                        CentreID=HttpContext.Current.Session["CentreID"],
                                        AlmID=rackID,
                                        UpdateID=HttpContext.Current.Session["ID"].ToString(),

                                 });
                                for (int i = 0; i < Util.GetInt(noOfShelf); i++)
                                {
                                    string sqlLocationmaster = "insert into mrd_location_master (RmID, AlmID, ShelfNo, CurPos, MaxPos, AdditionalNo, IsActive, UserID,IPAddress,CentreID,EntDate ) values(@RmID,@AlmID,@ShelfNo,0,@MaxPos,0,@IsActive,@UserID,@IPAddress,@CentreID,NOW())";
                                    excuteCMD.DML(tnx, sqlLocationmaster, CommandType.Text, new
                                    {
                                        RmID = roomID,
                                        AlmID = rackID,
                                        ShelfNo = i + 1,
                                        MaxPos = noOfMaximumfile,
                                        IsActive = IsActive,
                                        UserID = HttpContext.Current.Session["ID"].ToString(),
                                        CentreID = HttpContext.Current.Session["CentreID"],
                                        IPAddress = HttpContext.Current.Request.UserHostAddress,
                                    });
                                }

                                message = " Rack Update Successfully ";
                                tnx.Commit();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message, Type = "Update" }); }

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

 
    }

    [WebMethod]
    public static string BindMRDRack(string roomID)
    {
        DataTable dt = StockReports.GetDataTable(" SELECT AlmID,Name FROM mrd_almirah_master where centreID=" + HttpContext.Current.Session["CentreID"] + " and RmID=" + roomID + "; ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string bindRackDetail(string RackID)
    {
        DataTable dt = StockReports.GetDataTable("select Name,NoOfShelf,MaximumNoofFiles,IF(IsActive=1,'Yes','No')Active from mrd_almirah_master where CentreID=" + HttpContext.Current.Session["CentreID"] + " AND AlmID='" + RackID + "'");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
}
    
