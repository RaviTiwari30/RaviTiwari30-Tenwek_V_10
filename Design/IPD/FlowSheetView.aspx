<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FlowSheetView.aspx.cs" Inherits="Design_IPD_FlowSheetView" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/Time.ascx" TagName="StartTime" TagPrefix="uc2" %>
  
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="../../Scripts/ipad.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/CPOE_AddToFavorites.js"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>    
    <link rel="Stylesheet" href="../../Scripts/fancybox/jquery.fancybox-1.3.4.css" type="text/css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.mousewheel-3.0.4.pack.js"></script>
  <%--  <script type="text/javascript" src="../../Scripts/CheckUnSaveData.js"></script>--%>
    
<script type="text/javascript">   
   
    $(document).ready(function () {
        $('#chkLabs').change(function () {
            if ($("#chkLabs").prop('checked') == true) {
                $("#divLabs").show();
            }
            else {
                $("#divLabs").hide();
            }

            
        });
        $('#chkDocNotes').change(function () {
            if ($("#chkDocNotes").prop('checked') == true) {
                $("#divDocNotes").show();
            }
            else {
                $("#divDocNotes").hide();
            }
        });
        $('#chkMedication').change(function () {
            if ($("#chkMedication").prop('checked') == true) {
                $("#divMedication").show();
            }
            else {
                $("#divMedication").hide();
            }
        });
        $('#chkVitals').change(function () {
            if ($("#chkVitals").prop('checked') == true) {
                $("#divVitals").show();
            }
            else {
                $("#divVitals").hide();
            }
        });

        // createTable(sd,0,tid);
       // bindIntake(sd, 0, tid);

       // createMedicationTable(sd, 0, tid);
       
        $('#ddlMonthDuration').on('change', '', function (e) {
            var sd = '20210419';
            var span = $('#ddlMonthDuration').val()
            var spandays = $('#ddlDayDuration').val()
            var pid = '<%=Request.QueryString["PatientId"]%>';
            var PType = '<%=Request.QueryString["PType"]%>';
            createVitalTable(sd, span, spandays, pid);

            createTable(sd, span, spandays, pid);

            createDocNotesTable(sd, span, spandays, pid);

            createMedicationTable(sd, span, spandays, pid, PType);

        });
        $('#ddlDayDuration').on('change', '', function (e) {
            var sd = '20210419';

            var span = $('#ddlMonthDuration').val()
            var spandays = $('#ddlDayDuration').val()
            //var pid = '180457';
            var pid = '<%=Request.QueryString["PatientId"]%>';
            var PType = '<%=Request.QueryString["PType"]%>'

            createVitalTable(sd, span, spandays, pid);

            createTable(sd, span, spandays, pid);

            createDocNotesTable(sd, span, spandays, pid);

            createMedicationTable(sd, span, spandays, pid, PType);

        });

        // Requirement came by default data should be load for 1month.
        $('#ddlMonthDuration').val('1');
        var pid = '<%=Request.QueryString["PatientId"]%>';
        var PType = '<%=Request.QueryString["PType"]%>'
        createVitalTable('20210419', '1', '0', pid);
        createTable('20210419', '1', '0', pid);
        createDocNotesTable('20210419', 1, 0, pid);
        createMedicationTable('20210419', '1', '0', pid, PType);


    });
    function createVitalTable(sd, span, spandays, pid) {
        jQuery.ajax({
            type: "POST",
            url: "FlowSheetView.aspx/FillVitalDiv",
            data: '{sdate:"' + sd + '",span:"' + span + '",spandays:"' + spandays + '",PID:"' + pid + '"}',
            dataType: "json",
            contentType: "application/json;charset=UTF-8",
            success: function (response) {
                //alert(response.d);
                $("#divVitals").html(response.d);
                bindVitals(sd, span, spandays, pid);

            },
            error: function (xhr, status) {

            }
        });
    }
    function createTable(sd, span, spandays, pid) {
        jQuery.ajax({
            type: "POST",
            url: "FlowSheetView.aspx/FillDiv",
            data: '{sdate:"' + sd + '",span:"' + span + '",spandays:"' + spandays + '",PID:"' + pid + '"}',
            dataType: "json",
            contentType: "application/json;charset=UTF-8",
            success: function (response) {
                //alert(response.d);
                $("#divLabs").html(response.d);
                bindIntake(sd, span, spandays, pid);

            },
            error: function (xhr, status) {

            }
        });
    }
    function createDocNotesTable(sd, span, spandays, pid) {
        jQuery.ajax({
            type: "POST",
            url: "FlowSheetView.aspx/FillDocNotesTable",
            data: '{sdate:"' + sd + '",span:"' + span + '",spandays:"' + spandays + '",PID:"' + pid + '"}',
            dataType: "json",
            contentType: "application/json;charset=UTF-8",
            success: function (response) {
                //alert(response.d);
                $("#divDocNotes").html(response.d);
                bindDocNotes(sd, span, spandays, pid);
            },
            error: function (xhr, status) {

            }
        });
    }
    function createMedicationTable(sd, span, spandays, pid, PType) {
        jQuery.ajax({
            type: "POST",
            url: "FlowSheetView.aspx/FillMedicationTable",
            data: '{sdate:"' + sd + '",span:"' + span + '",spandays:"' + spandays + '",PID:"' + pid + '",PType:"' + PType + '"}',
            dataType: "json",
            contentType: "application/json;charset=UTF-8",
            success: function (response) {
                //alert(response.d);
                $("#divMedication").html(response.d);
                bindMedication(sd, span, spandays, pid, PType);

            },
            error: function (xhr, status) {

            }
        });
    }
    function bindVitals(sd, span, spandays, pid) {
        jQuery.ajax({
            type: "POST",
            url: "FlowSheetView.aspx/bindVitals",
            data: '{sdate:"' + sd + '",span:"' + span + '",spandays:"' + spandays + '",PID:"' + pid + '"}',
            dataType: "json",
            contentType: "application/json;charset=UTF-8",
            success: function (response) {
                Newitem = jQuery.parseJSON(response.d);

                if (Newitem != null) {
                    var head = "";
                    $.each(Newitem, function (index, obj) {

                        //if ($('#tr' + obj["ID"]).length)
                        {
                            /* it exists */
                            var dt = obj["class"];
                            $("#trBP").find("." + dt).html(obj["BP"]);
                            $("#trPulse").find("." + dt).html(obj["P"]);
                            $("#trResp").find("." + dt).html(obj["R"]);
                            $("#trT").find("." + dt).html(obj["T"]);
                            $("#trHT").find("." + dt).html(obj["HT"]);
                            $("#trWT").find("." + dt).html(obj["WT"]); 
                            $("#trSPO2").find("." + dt).html(obj["SPO2"]);
                            $("#trBloodGlucose").find("." + dt).html(obj["CBG"]);
                           
                            

                        }
                        //else {

                        //}
                    });
                }

                else {

                }
                if ($("#chkVitals").prop('checked') == true) {
                    $("#divVitals").show();
                }
                else {
                    $("#divVitals").hide();
                }
            },
            error: function (xhr, status) {

            }
        });
    }

    function bindIntake(sd, span, spandays, pid) {
        jQuery.ajax({
            type: "POST",
            url: "FlowSheetView.aspx/bindData",
            data: '{sdate:"' + sd + '",span:"' + span + '",spandays:"' + spandays + '",PID:"' + pid + '"}',
            dataType: "json",
            contentType: "application/json;charset=UTF-8",
            success: function (response) {
                Newitem = jQuery.parseJSON(response.d);
                $("tr.item").each(function () {
                    var inv = $(this).find("td.Parameter").html();
                    localStorage.setItem(inv, '');
                });
                if (Newitem != null) {
                    var head = "";
                    $.each(Newitem, function (index, obj) {

                                //if ($('#tr' + obj["ID"]).length)
                                {
                                    /* it exists */
                                    var dt = obj["Date"].substring(0, 10).replace("-", "").replace("-", "");
                                    //$("#tr" + obj["ID"] + "").find("." + dt + "").find("#trl" + obj["ID"] + obj["Date"] + "").append( "<td>" + obj["Value"] + "</td>");
                                   
                                    $.each($("tr.item"),function (i,ob) {
                                        var inv =$( ob).find("td.Parameter").html();
                                        
                                        if (inv == obj["LabObservationName"]) {
                                         
                                            if ($(ob).find("." + dt + "").html() != "") {
                                                
                                                    localStorage.setItem(inv, localStorage.getItem(inv) + ',' + obj["VALUE"]);

                                                    $(ob).find("." + dt + "").html(localStorage.getItem(inv));
                                                
                                               
                                            }
                                            else {

                                                localStorage.setItem(inv,  obj["VALUE"]);
                                            $(ob).find("." + dt + "").html(obj["VALUE"]);
                                            
                                            }

                                           $( ob).find(".Diffference").html(obj["Diffference"]);

                                           
                                            
                                        }
                                        else {

                                            //$("#tr" + obj["ID"] + "").find("." + dt + "").html( obj["VALUE"] );
                                            $("#tr" + obj["ID"] + "").find(".Parameter").html(obj["LabObservationName"]);
                                            if (head != obj["NAME"]) {
                                                $("#tr" + obj["ID"] + "").find(".Investigation").html("<span style='font-weight:bold;color:Blue;'>" + obj["NAME"].toUpperCase() + "</span></b>");

                                              head = obj["NAME"];
                                            }
                                            //$("#tr" + obj["ID"] + "").find(".Investigation").html(obj["NAME"]);

                                            $("#tr" + obj["ID"] + "").find(".Diffference").html(obj["Diffference"]);

                                           
                                        }

                                    });
                                    
                                }
                                //else {
                                    
                                //}
                            });
                                                   }

                        else {
                           
                        }
                        if ($("#chkLabs").prop('checked') == true)
                        {
                            $("#divLabs").show();
                        }
                        else
                        {
                            $("#divLabs").hide();
                        }
                        $("tr.item").each(function () {
                            var inv = $(this).find("td.Parameter").html();
                            localStorage.setItem(inv, '');
                        });

                    },
                    error: function (xhr, status) {

                    }
                });
    }
    function bindDocNotes(sd, span, spandays, pid) {
        jQuery.ajax({
            type: "POST",
            url: "FlowSheetView.aspx/bindDocNotes",
            data: '{sdate:"' + sd + '",span:"' + span + '",spandays:"' + spandays + '",PID:"' + pid + '"}',
            dataType: "json",
            contentType: "application/json;charset=UTF-8",
            success: function (response) {
                Newitem = jQuery.parseJSON(response.d);

                if (Newitem != null) {
                    $.each(Newitem, function (index, obj) {

                        if ($('#trd').length) {
                            /* it exists */
                            var dt = obj["Date"].substring(0, 10).replace("-", "").replace("-", "");
                            var str = "<a target='pagecontent'  id='' name='a'  style='cursor: pointer;color:blue;text-decoration: underline;' onClick='showuploadbox("+obj["TransactionId"]+");' style='color:yellow;' >Doctor Notes</a>";
                            $("#trd").find("." + dt + "").html(str);
                            }
                        else {

                        }
                    });
                }

                else {

                }

                if ($("#chkDocNotes").prop('checked') == true)
                {
                    $("#divDocNotes").show();
                }
                else {
                    $("#divDocNotes").hide();
                }
            },
            error: function (xhr, status) {

            }
        });
    }
    function bindMedication(sd, span, spandays, pid, PType) {
        jQuery.ajax({
            type: "POST",
            url: "FlowSheetView.aspx/bindMedication",
            data: '{sdate:"' + sd + '",span:"' + span + '",spandays:"' + spandays + '",PID:"' + pid + '",PType:"' + PType + '"}',
            dataType: "json",
            contentType: "application/json;charset=UTF-8",
            success: function (response) {
                Newitem = jQuery.parseJSON(response.d);

                if (Newitem != null) {
                    $.each(Newitem, function (index, obj) {

                        //if ($('#trm' + obj["Id"]).length)
                        {
                            /* it exists */
                            var dt = obj["DATE"].substring(0, 10).replace("-", "").replace("-", "");

                            $("tr.item1").each(function () {
                                var inv = $(this).find("td.Medication").html();
                                if (inv == obj["MedicineName"]) {
                                    $(this).find("." + dt + "").html("Duration:-" + obj["Duration"] + "<br/>Dose:-" + obj["Dose"] + "<br/>Quantity:-" + obj["ReqQty"]);
                                    

                                }
                                else {
                                    $("#trm" + obj["Id"] + "").find("." + dt + "").html("Duration:-" + obj["Duration"] + "<br/>Dose:-" + obj["Dose"] + "<br/>Quantity:-" + obj["ReqQty"]);
                                    $("#trm" + obj["Id"] + "").find(".Medication").html(obj["MedicineName"]);
                                    
                                }
                            });
                           }
                        //else {

                        //}
                    });
                }

                else {

                }
                if ($("#chkMedication").prop('checked')==true)
                {
                    $("#divMedication").show();
                }
                else {
                    $("#divMedication").hide();
                }

              
            },
            error: function (xhr, status) {

            }
        });
    }
    function showuploadbox(tid) {
        $.fancybox({
            maxWidth: 1050,
            maxHeight: 1050,
            fitToView: false,
            width: '73%',
            href: "./DoctorProgressNote.aspx?PatientId=180474&amp;TransactionId="+tid+"&amp;flag=1",
            height: '73%',
            autoSize: false,
            closeClick: false,
            openEffect: 'none',
            closeEffect: 'none',
            'type': 'iframe'
        });
    }

        </script>
    <style type="text/css">
         #divVitals {
  font-family: Arial, Helvetica, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

#divVitals td, #divVitals th {
  border: 1px solid #ddd;
  padding: 2px;

}

#divVitals tr:nth-child(even){background-color: #f2f2f2;}

#divVitals tr:hover {background-color: #ddd;}

#divVitals th {
  padding-top: 2px;
  padding-bottom: 2px;
 /* text-align: left;*/
  background-color: #04AA6D;
  color: white;
}


        #divLabs {
  font-family: Arial, Helvetica, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

#divLabs td, #divLabs th {
  border: 1px solid #ddd;
  padding: 2px;

}

#divLabs tr:nth-child(even){background-color: #f2f2f2;}

#divLabs tr:hover {background-color: #ddd;}

#divLabs th {
  padding-top: 2px;
  padding-bottom: 2px;
 /* text-align: left;*/
  background-color: #04AA6D;
  color: white;
}
       #divDocNotes {
  font-family: Arial, Helvetica, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

#divDocNotes td, #divDocNotes th {
  border: 1px solid #ddd;
  padding: 2px;
}

#divDocNotes tr:nth-child(even){background-color: #f2f2f2;}

#divDocNotes tr:hover {background-color: #ddd;}

#divDocNotes th {
  padding-top: 2px;
  padding-bottom: 2px;
  text-align: left;
  background-color: #04AA6D;
  color: white;
}
      #divMedication {
  font-family: Arial, Helvetica, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

#divMedication td, #divMedication th {
  border: 1px solid #ddd;
  padding: 2px;
}

#divMedication tr:nth-child(even){background-color: #f2f2f2;}

#divMedication tr:hover {background-color: #ddd;}

#divMedication th {
  padding-top: 2px;
  padding-bottom: 2px;
  text-align: left;
  background-color: #04AA6D;
  color: white;
}
        #divDocNotes,divLabs,divMedication {
   
   overflow-y: auto;
   overflow-x: auto;
}
        .style2 {
            font-size: x-small;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
       <cc1:ToolkitScriptManager ID="toolScriptManageer1" runat="server"></cc1:ToolkitScriptManager> 
        <%--<div>&nbsp;&nbsp;&nbsp;<a id="AddToFavorites" onclick="AddPage('cpoe_Vital.aspx','Vital Sign')" href="#">Add To Favorites</a>&nbsp;&nbsp;&nbsp;&nbsp;<span id="Msg" class="ItDoseLblError"></span></div>--%>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Flow Sheet</b><br />
                <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
              <div class="content">
                            



                        </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    FlowSheet View
                </div>
                <div class="row">
        <div class="col-md-24">
            <div class="col-md-12">
                 <input type="checkbox" id="chkLabs" name="vehicle1" value="Bike" checked="checked" >
                <label for="Lab"> Lab</label>
                <input type="checkbox" style="display:none" id="chkDocNotes" name="vehicle2" value="Car">
                <label for="DocNotes" style="display:none"> Doc Notes</label>
                <input type="checkbox" id="chkMedication" name="vehicle3" value="Boat" checked="checked">
                <label for="Medication"> Medication</label>
                <input type="checkbox" id="chkVitals" name="vehicle3" value="Boat" checked="checked">
                <label for="Vitals"> Vitals</label>
                       
                       </div>
            <div class="col-md-2">Days
                </div>
            <div class="col-md-4">
                <select id="ddlDayDuration">
                    <option value="0">--Select--</option>
                    <option value="1">1 Days</option>
                    <option value="2">2 Days</option>
                    <option value="3">3 Days</option>
                    <option value="4">4 Days</option>
                    <option value="5">5 Days</option>
                    <option value="6">6 Days</option>
                    <option value="7">7 Days</option>
                    <option value="8">8 Days</option>
                    <option value="9">9 Days</option>
                    <option value="10">10 Days</option>
                    <option value="11">11 Days</option>
                    <option value="12">12 Days</option>
                    <option value="13">13 Days</option>
                    <option value="14">14 Days</option>
                    <option value="15">15 Days</option>
                    <option value="16">16 Days</option>
                    <option value="17">17 Days</option>
                    <option value="18">18 Days</option>
                    <option value="19">19 Days</option>
                    <option value="20">20 Days</option>
                    <option value="21">21 Days</option>
                    <option value="22">22 Days</option>
                    <option value="23">23 Days</option>
                    <option value="24">24 Days</option>
                    <option value="25">25 Days</option>
                    <option value="26">26 Days</option>
                    <option value="27">27 Days</option>
                    <option value="28">28 Days</option>
                    <option value="29">29 Days</option>
                    <option value="30">30 Days</option>
                    <option value="31">31 Days</option>
                </select>
        </div>
            <div class="col-md-2">
                Months
                </div>
            
            <div class="col-md-4">
                <select id="ddlMonthDuration">
                    <option value="0">--Select--</option>
                    <option value="1">1 Month</option>
                    <option value="2">2 Month</option>
                    <option value="3">3 Month</option>
                    <option value="4">4 Month</option>
                    <option value="5">5 Month</option>
                    <option value="6">6 Month</option>
                    <option value="7">7 Month</option>
                    <option value="8">8 Month</option>
                    <option value="9">9 Month</option>
                    <option value="10">10 Month</option>
                    <option value="11">11 Month</option>
                    <option value="12">12 Month</option>
                </select>
        </div>
        </div>
    </div>


            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
           <div class="Purchaseheader">
                    VITALS
                </div>
                
                 <div class="row">
        <div class="col-md-24">
            <div id="divVitals" runat="server">
             
                </div>


                    </div>
    </div>
                
                 <div class="Purchaseheader">
                    LABS
                </div>
                
                 <div class="row">
        <div class="col-md-24">
            <div id="divLabs" runat="server">
             
                </div>


                    </div>
    </div>
                <div class="Purchaseheader" style="display:none">
                   DOC NOTES
                </div>
                
                 <div class="row" style="display:none">
        <div class="col-md-24">
            <div id="divDocNotes">
             
                </div>


                    </div>
    </div>
                <div class="Purchaseheader">
                    MEDICATION
                </div>
                
                 <div class="row">
        <div class="col-md-24">
            <div id="divMedication">
             
                </div>


                    </div>
    </div>
                   </div>
            
        </div>

    </form>
</body>
</html>
