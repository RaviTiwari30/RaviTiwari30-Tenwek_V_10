using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Mac_Observation
/// </summary>

    public class Mac_Observation
    {
        public string LabNo { get; set; }
        public string Machine_Id { get; set; }
        public string Machine_ParamID { get; set; }
        public string Reading { get; set; }
        public int isActive { get; set; }
        public string PatientName { get; set; }
        public string PatientId { get; set; }
        public DateTime dtRun { get; set; }
        public DateTime dtEntry { get; set; }
        public int isSync { get; set; }
        public string GroupId { get; set; }
        public string UpdateReason { get; set; }
        public string UpdateBy { get; set; }
        public int Type { get; set; }
        public string ParamName { get; set; }
        public string Interpretation { get; set; }
        public string ObservationName { get; set; }
    }
