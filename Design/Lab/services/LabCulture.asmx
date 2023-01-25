<%@ WebService Language="C#" Class="LabCulture" %>



using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using Newtonsoft;
using System.Data;
using System.Text;
using System.Collections.Generic;
using System.Web.Script.Services;
using System.Linq;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class LabCulture  : System.Web.Services.WebService {

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }

   

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string getmasterdata(string typeid, string typename)
    {
        string query = "SELECT id,Code,NAME,IF(isactive='1','Active','Deactive') STATUS,isactive,typeid,typename,InsertByname,UpdateByname,";
        query += " DATE_FORMAT(InsertDate,'%d-%b-%Y %h:%I') entrydate,";
        query += " DATE_FORMAT(UpdateDate,'%d-%b-%Y %h:%I') updatedate ";
        query += " FROM micro_master ";
        query += " where typeid='" + typeid + "' order by name";
        
        
        DataTable dtoutput = StockReports.GetDataTable(query);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtoutput);
    }
    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string updatemasterdata(string id,string name, string status, string code)
    {
        string query = "update  micro_master set NAME='" + name + "',Isactive='" + status + "',code='" + code + "'";
        query += ",UpdatebyId= '" + HttpContext.Current.Session["ID"].ToString() + "',UpdateByname='" + HttpContext.Current.Session["LoginName"].ToString() + "',UpdateDate=now()";
        query += " where id='"+id+"' ";
        try
        {
            StockReports.ExecuteDML(query);
            return "1";

        }
        catch (Exception ex) 
        {
            return ex.InnerException.Message;
        }
    }
    
    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string savemasterdata(string typeid, string typename, string name, string status,string code)
    {
        string query = "INSERT INTO micro_master(NAME,Isactive,typeid,typename,CODE,InsertById,InsertByname,InsertDate) ";
        query += " VALUES ('" + name + "','" + status + "','" + typeid + "','" + typename + "','" + code + "',";
        query += " '" +HttpContext.Current.Session["ID"].ToString() + "','" + HttpContext.Current.Session["LoginName"].ToString() + "',NOW()) ";
        try
        {
            StockReports.ExecuteDML(query);
            return "1";

        }
        catch(Exception ex)
        {
            return ex.InnerException.Message;
        }
        
    }
    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string getunmappeddata(string searchtype,string masterid)
    {
        string query = "SELECT id,NAME NAME,typeid FROM micro_master WHERE  isactive='1' ";

        if (searchtype == "6")//Organism To Antibiotic	
        {
        

            query += " AND typeid='4' and id NOT IN(SELECT mapmasterid FROM micro_master_mapping WHERE masterid='" + masterid + "' and maptypeid=1)";

        }
        
        if (searchtype == "4")//Antibiotic Group To Antibiotic	
        {


            query += " AND typeid='4' and AntibioticGroupToAntibiotic=0";

        }
        
       
        //query += " and id NOT IN(SELECT mapmasterid FROM micro_master_mapping WHERE masterid='" + masterid + "') ";
        query += " order by NAME ";
   
        DataTable dt = StockReports.GetDataTable(query);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string getsaveddata(string searchtype, string masterid)
    {
        string query = " SELECT mmm.mapid ,mmm.mapmasterid,mm.name FROM micro_master_mapping mmm  INNER JOIN  micro_master mm ON mmm.mapmasterid=mm.id ";
        query += "WHERE mmm.masterid='" + masterid + "'";
        if (searchtype == "6")//Organism To Antibiotic	
        {
            query += "   AND mmm.maptypeid='1'  ";
        }
        if (searchtype == "4")//Antibiotic Group To Antibiotic	
        {
            query += "  AND mmm.maptypeid='2' and AntibioticGroupToAntibiotic=1 ";
        }
      
        query += " order by mm.NAME ";
    
        DataTable dt = StockReports.GetDataTable(query);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string savemapping(string typeid, string masterid, string maptypeid, List<string> mapmasterid, string breakpoint)
    {

        
      try
        {
          
           
        foreach (string mmid in mapmasterid)
        {
            string query = " INSERT INTO micro_master_mapping (typeid,masterid,maptypeid,mapmasterid,breakpoint,Insertdate,InsertById,InsertByName) ";
            query += " VALUES ";
            query += "('" + typeid + "','" + masterid + "','"+maptypeid+"','" + mmid + "','" + breakpoint + "',now(),";
            query += "'" + HttpContext.Current.Session["ID"].ToString() + "','" + HttpContext.Current.Session["LoginName"].ToString() + "')";
       
            StockReports.ExecuteDML(query);
            if (maptypeid == "4")
            {
                string q = " update micro_master set AntibioticGroupToAntibiotic='1' where id='" + mmid + "' ";
                StockReports.ExecuteDML(q);
            }
          
        }
            return "1";

        }
        catch (Exception ex)
        {
            return ex.InnerException.Message;
        }
    }
    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string deletemapping(List<string> mapid,string maptypeid)
    {
        
        try
        {
            foreach (string id in mapid)
            {
                string q = "select mapmasterid,maptypeid from micro_master_mapping where mapid='" + id + "'";
                string mid = StockReports.GetDataTable(q).Rows[0]["mapmasterid"].ToString();
                
                StockReports.ExecuteDML("delete from micro_master_mapping where mapid='" + id + "'");
                if (maptypeid == "4")
                {
                    StockReports.ExecuteDML("update micro_master set AntibioticGroupToAntibiotic=0 where id='" + mid + "' ");
                }
           
                
              
                
            }
            return "1";

        }
        catch (Exception ex)
        {
            return ex.InnerException.Message;
        }
    }
    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetAntibioticList(string groupid)
    {
        DataTable dt = StockReports.GetDataTable(@"SELECT mmm.mapid ,mmm.mapmasterid,mm.name,mmm.breakpoint FROM micro_master_mapping mmm  INNER JOIN  micro_master mm ON mmm.mapmasterid=mm.id
WHERE mmm.masterid='" + groupid + "' AND mmm.maptypeid='6' order by name");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        
    }
    
    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveBreakPoint(List<string[]> mydata)
    {
        try
        {
            foreach (string[] ss in mydata)
            {
                StockReports.ExecuteDML("update micro_master_mapping set breakpoint='" + ss[1].ToString() + "' where mapid='" + ss[0].ToString() + "'");

            }
            return "1";
        }
        catch (Exception ex)
        {
            return ex.InnerException.Message;
        }
    }
    
  

}