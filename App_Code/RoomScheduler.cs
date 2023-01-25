using System;
using System.Web.Services;


/// <summary>
/// Summary description for RoomScheduler
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
public class RoomScheduler : System.Web.Services.WebService {

    public RoomScheduler () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public void Scheduler()
    {
        //RoomBilling RBill = new RoomBilling();
        //RBill.getAllAdmittedPatient();        

        SchedulerClass SC = new SchedulerClass();
        SC.SaveIPDDataFromScheduler("IPD-ROOMBILLING", "2", "8");        
        SC.SaveIPDDataFromScheduler("IPD-NURSHINGBILLING", "24", "0");
       // SC.SaveIPDDataRmoChargesFromScheduler("IPD-RMOBILLING", "27", "10");
        // SC.SaveIPDDataFromScheduler("IPD-CONSULTANTVISIT", "1", "16");

    }

     [WebMethod]
    public static string abc(string ab) {

        return ab;
     }
}

