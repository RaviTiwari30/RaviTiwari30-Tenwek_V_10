using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for Patient_lab_ObservationOPD_MIC
/// </summary>
public class Patient_lab_ObservationOPD_MIC
{


    


  

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

  

   
    public Patient_lab_ObservationOPD_MIC()
	{
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        
	}

    public Patient_lab_ObservationOPD_MIC(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

   

  

    public  string testid{set;get;}


    public string labobservation_id { set; get; }
   

    public  string labobservation_name{set;get;}


    public string value { set; get; }
   

    public  string unit{set;get;}

    public string LabObservationComment { set; get; }

    public  string OrganismID {set;get;}
   

    public  string OrganismName{set;get;}
   

    public  string OrganismGroupID{set;get;}


    public string OrganismGroupName { set; get; }
   

    public  string EnzymeId{set;get;}


    public string Enzymename { set; get; }


    public string Enzymevalue { set; get; }
   

    public  string EnzymeUnit{set;get;}




    public string Antibioticid { set; get; }


    public string AntibioticName { set; get; }


    public string AntibioticGroupid { set; get; }


    public string AntibioticGroupname { set; get; }



    public string AntibioticInterpreatation { set; get; }


    public string MIC { set; get; }


    public string BreakPoint { set; get; }


    public string MIC_BP { set; get; }




    public string Reporttype { set; get; }


    public DateTime ResultEntrydateTime { set; get; }


    public int Result_flag { set; get; }



    public int Approved { set; get; }


    public string IPAddress { set; get; }
   
  
 
   
    

  
    public int Insert()
    {
        try
        {
            int iPkValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_Lab_ObservationOPDMIC");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@ID";
            paramTnxID.MySqlDbType = MySqlDbType.Int32;
            paramTnxID.Size = 10;
            paramTnxID.Direction = ParameterDirection.Output;


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;


            this.testid = Util.GetString(testid);
            this.labobservation_id = Util.GetString(labobservation_id);
            this.labobservation_name = Util.GetString(labobservation_name);
            this.value = Util.GetString(value);
            this.unit = Util.GetString(unit);
            this.LabObservationComment = Util.GetString(LabObservationComment);
            this.OrganismID = Util.GetString(OrganismID);
            this.OrganismName = Util.GetString(OrganismName);
            this.OrganismGroupID = Util.GetString(OrganismGroupID);
            this.OrganismGroupName = Util.GetString(OrganismGroupName);
            this.EnzymeId = Util.GetString(EnzymeId);
            this.Enzymename = Util.GetString(Enzymename);
            this.Enzymevalue = Util.GetString(Enzymevalue);
            this.EnzymeUnit = Util.GetString(EnzymeUnit);
            this.Antibioticid = Util.GetString(Antibioticid);
            this.AntibioticName = Util.GetString(AntibioticName);
            this.AntibioticGroupid = Util.GetString(AntibioticGroupid);
            this.AntibioticGroupname = Util.GetString(AntibioticGroupname);
            this.AntibioticInterpreatation = Util.GetString(AntibioticInterpreatation);
            this.MIC = Util.GetString(MIC);
            this.BreakPoint = Util.GetString(BreakPoint);
            this.MIC_BP = Util.GetString(MIC_BP);
            this.Reporttype = Util.GetString(Reporttype);
            this.ResultEntrydateTime = Util.GetDateTime(ResultEntrydateTime);
            this.Result_flag = Util.GetInt(Result_flag);
            this.Approved = Util.GetInt(Approved);
            this.IPAddress = Util.GetString(IPAddress);


            cmd.Parameters.Add(new MySqlParameter("@testid", testid));
            cmd.Parameters.Add(new MySqlParameter("@labobservation_id", labobservation_id));
            cmd.Parameters.Add(new MySqlParameter("@labobservation_name", labobservation_name));
            cmd.Parameters.Add(new MySqlParameter("@value", value));
            cmd.Parameters.Add(new MySqlParameter("@unit", unit));
            cmd.Parameters.Add(new MySqlParameter("@labobservationcomment", LabObservationComment));
            cmd.Parameters.Add(new MySqlParameter("@OrganismID", OrganismID));
            cmd.Parameters.Add(new MySqlParameter("@OrganismName", OrganismName));
            cmd.Parameters.Add(new MySqlParameter("@OrganismGroupID", OrganismGroupID));
            cmd.Parameters.Add(new MySqlParameter("@OrganismGroupName", OrganismGroupName));
            cmd.Parameters.Add(new MySqlParameter("@EnzymeId", EnzymeId));
            cmd.Parameters.Add(new MySqlParameter("@Enzymename", Enzymename));
            cmd.Parameters.Add(new MySqlParameter("@Enzymevalue", Enzymevalue));
            cmd.Parameters.Add(new MySqlParameter("@EnzymeUnit", EnzymeUnit));
            cmd.Parameters.Add(new MySqlParameter("@Antibioticid", Antibioticid));
            cmd.Parameters.Add(new MySqlParameter("@AntibioticName", AntibioticName));
            cmd.Parameters.Add(new MySqlParameter("@AntibioticGroupid",AntibioticGroupid));
            cmd.Parameters.Add(new MySqlParameter("@AntibioticGroupname", AntibioticGroupname));
            cmd.Parameters.Add(new MySqlParameter("@AntibioticInterpreatation", AntibioticInterpreatation));
            cmd.Parameters.Add(new MySqlParameter("@MIC", MIC));
            cmd.Parameters.Add(new MySqlParameter("@BreakPoint", BreakPoint));
            cmd.Parameters.Add(new MySqlParameter("@MIC_BP", MIC_BP));
            cmd.Parameters.Add(new MySqlParameter("@Reporttype", Reporttype));
            cmd.Parameters.Add(new MySqlParameter("@ResultEntrydateTime", ResultEntrydateTime));
            cmd.Parameters.Add(new MySqlParameter("@Result_flag", Result_flag));
            cmd.Parameters.Add(new MySqlParameter("@Approved", Approved));
            cmd.Parameters.Add(new MySqlParameter("@ResultEntryBy", HttpContext.Current.Session["ID"].ToString() ));
            cmd.Parameters.Add(new MySqlParameter("@ResultEntryByname", HttpContext.Current.Session["LoginName"].ToString()));
            cmd.Parameters.Add(new MySqlParameter("@IPAddress", IPAddress)); 
           
            cmd.Parameters.Add(paramTnxID);

            iPkValue = Util.GetInt(cmd.ExecuteNonQuery());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return iPkValue;
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

}