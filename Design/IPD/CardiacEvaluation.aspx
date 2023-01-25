<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CardiacEvaluation.aspx.cs" Inherits="Design_IPD_CardiacEvaluation" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <%-- <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>--%>
    <style type="text/css">
          .holder {
                position: relative;
            }
            .dropdown {
                width:500px;
                height:120px;
                overflow-y:auto;
                margin-top:25px;
                position: absolute;
                z-index:999;
                border: 1px solid black;
                display: none;
                background-color:white;
                color:black;
            }

            input:focus + .dropdown {
                display: block;
            }
        .deleted {
            display:none;
        }
        .ajax__scroll_none {
    overflow: visible !important;
    z-index: 10000 !important;
}
        #rdbUnderP td{
       width:200px;
             }
        #rdbTriceps td {
       width:200px;
             }
        #rdbRobs td {
       width:200px;
             }
        
        #rdbTemple td {
       width:200px;
             }
        #rdbClavicle  td {
       width:200px;
             }
        
        #rdbShoulder td {
       width:200px;
             }
        
        #rdbScapula  td {
       width:200px;
             }
        
        #rdbQuadriceps  td {
       width:200px;
             }
        
        #rdbInterrosseous  td {
       width:200px;
             }
           
        #rdbEdema  td {
       width:200px;
             }
        #rdbAscites  td {
       width:200px;
             }
    </style>
</head>

<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../../Scripts/shortcut.js"></script>
   <%-- <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css" />--%>
    <script type="text/javascript">
        function getDrugName(dn) {
            //alert(dn);
            if ($("#txtDrugs").val() == "") {
                $("#txtDrugs").val(dn);
            }
            else {
                $("#txtDrugs").val($("#txtDrugs").val() + " ," + dn);
            }
            $('.dropdown').hide();
        }
        function search() {
            var key = $('#txtDrugs1').val();
            //alert(key);
            jQuery.ajax({
                type: "POST",
                url: "CardiacEvaluation.aspx/BindSearch",
                data: '{key:"' + key + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                success: function (response) {
                    if ((response.d != null) && (response.d != "")) {
                        Newitem = jQuery.parseJSON(response.d);


                        var str = "<table style='width:100%;' border='1'>";
                        for (var i = 0; i < Newitem.length; i++) {
                            var objrow = Newitem[i];
                            str += "<tr><td class='GridViewLabItemStyle' ><a  onclick='getDrugName(&quot;" + objrow.NAME + "&quot;);'>" + objrow.NAME + "</a></td></tr>";

                        }
                        str += "</table>";
                        $(".dropdown").html(str);
                        $(".dropdown").show();
                    }
                },
                error: function (e) { }
            });
        }

        $(document).ready(function () {
            $("#<%=ddlOrdering.ClientID %>").chosen();
            $("#<%=ddlSONO.ClientID %>").chosen();
            $("#<%=ddlCounty.ClientID %>").chosen();
            
            $("#spnPatientID").text('<%=Request.QueryString["PID"].ToString() %>');
            $("#spnTransactionID").text('<%=Request.QueryString["TID"].ToString() %>');
            //bindData();
            $("#txtGlascowComaScaleScore").blur(function () {
                if ($("#txtGlascowComaScaleScore").val() > 20) {
                    modelAlert("Glascow Coma Scale Score can not exceed 20", function () {
                        $("#txtGlascowComaScaleScore").val("");
                        $("#txtGlascowComaScaleScore").focus();
                    });


                }
                else {
                    $("#lblGlascowComaScaleScore1").text($("#txtGlascowComaScaleScore").val());
                }

            });
        });
        function validate() {

            if ($("#ddlOrdering").val() == "0") {
                modelAlert("Please Select Ordering Physician.", function () { });
                return false;
            }
            if ($("#txtHistory").val() == "") {
                modelAlert("Please Fill History.", function () { });
                return false;
            }
        }

    </script>

    <form id="form2" runat="server">
        
        <div class="POuter_Box_Inventory" style="text-align: center;">
             <div class="Purchaseheader" style="text-align: center">
                  <b>Tenwek Hospital Cardiac Evaluation EchoCardiogram Report</b>
                </div>
 
             
                <br />
            
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
           <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
            
 
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="row">
                    <div class="col-md-2" >Date
                        </div>
                     <div class="col-md-5">
                          <span  style="display:none;"  id="spnTransactionID"></span>
                   
                        <span style="display:none;" id="spnPatientID"></span>
                        
                        <span  style="display:none;"  id="spnEditPatientNote"></span>
                                   <asp:TextBox ID="txtDate" CssClass="requiredField" runat="server"  Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="txtDate"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>
                           
                        </div>
                     <div class="col-md-2" >Time
                        </div>
                     <div class="col-md-8">
                          <asp:TextBox ID="txtTime" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTime"
                                    Mask="99:99" MaskType="Time" AcceptAMPM="true" />

                                <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtTime"
                                    ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                    InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                          
                                <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                            
                        </div>
                    </div>
                </div>
                  <div class="POuter_Box_Inventory" style="text-align: left;">
                <div class="row">
                    <div class="col-md-24">
                             <table style="width:100%;" class="FixedTables" >
                                     <tr>
                                         
                            <td class="GridViewLabItemStyle"   colspan="1"    >Ordering Physician
                                </td>
                            <td class="GridViewLabItemStyle"   colspan="1"    >
                                <asp:DropDownList id="ddlOrdering" runat="server" Width="200px">
                                        </asp:DropDownList>
                        
                            </td>
                            <td class="GridViewLabItemStyle"   colspan="1"    ></td></tr>
                                 <tr>
                                         
                            <td class="GridViewLabItemStyle"   colspan="1"    >Primary School
                                </td>
                            <td class="GridViewLabItemStyle"   colspan="1"    >
                                <asp:TextBox ID="txtPrimary" runat="server"  Width="200px"   ClientIDMode="Static" ></asp:TextBox>
                          
                            </td>
                            <td class="GridViewLabItemStyle"   colspan="1"    ></td></tr>
                                 <tr>
                                         
                            <td class="GridViewLabItemStyle"   colspan="1"    >County
                                </td>
                            <td class="GridViewLabItemStyle"   colspan="1"    >
                                <asp:DropDownList id="ddlCounty" runat="server" Width="200px">
                                        </asp:DropDownList>
                        
                            </td>
                            <td class="GridViewLabItemStyle"   colspan="1"    ></td></tr><tr>
                                         
                            <td class="GridViewLabItemStyle"   colspan="1"    >Height(CM):&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblHeight" runat="server" ></asp:Label>
                                </td>
                                
                            <td class="GridViewLabItemStyle"   colspan="1"    >Weight(KG):&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblWeight" runat="server" ></asp:Label>
                          
                            </td>
                            <td class="GridViewLabItemStyle"   colspan="1"    ></td></tr>
                                   <tr>
                                         
                            <td class="GridViewLabItemStyle"   colspan="1"    >Telephone No:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblTelephone" runat="server" ></asp:Label>
                                </td>
                                
                            <td class="GridViewLabItemStyle"   colspan="1"    >Pager /Phone:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <asp:TextBox ID="txtPhone" MaxLength="10" runat="server"  Width="200px"   ClientIDMode="Static" ></asp:TextBox>
                           <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender17" runat="server" TargetControlID="txtPhone" ValidChars="0987654321-">
                                </cc1:FilteredTextBoxExtender>
                                
                          
                            </td>
                            <td class="GridViewLabItemStyle"   colspan="1"    ></td></tr>
                             
                            <tr >
                                <th class="GridViewLabItemStyle" scope="col" colspan="3" >History</th>
                                

                            </tr>
                                 <tr>
                            <td class="GridViewLabItemStyle"   colspan="3"    >
                                <asp:TextBox ID="txtHistory" CssClass="" runat="server" TextMode="MultiLine"   ClientIDMode="Static"  ></asp:TextBox>
                               

                            </td></tr>
                                      <tr>
                            <td class="GridViewLabItemStyle"   colspan="1"    >NYHA class
                                </td>
                            <td class="GridViewLabItemStyle"   colspan="2"    >
                                <asp:RadioButtonList ID="rdbNYHA" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >I</asp:ListItem>
                                          <asp:ListItem Value="2">II</asp:ListItem>
                                          <asp:ListItem Value="3">III</asp:ListItem>
                                          <asp:ListItem Value="4">IV</asp:ListItem>
                                          
                                      </asp:RadioButtonList>


                            </td></tr>
                                 
                                      <tr>
                            <td class="GridViewLabItemStyle"   colspan="1"    >Medications
                                </td>
                                          <td   colspan="2" >
                        <input type="text"   ID="txtDrugs1"  onkeyup="search();" placeholder="Search Medicine" /><br />
                                          <asp:TextBox ID="txtDrugs" CssClass="" runat="server" TextMode="MultiLine"   ClientIDMode="Static"  ></asp:TextBox>
                                <div class="dropdown"  style='width:500px;height:400px;display:none;z-index:999'>
                        </div>

                            </td></tr>
                                 <tr>
                            <td class="GridViewLabItemStyle"   colspan="1"    >
                                <table>
                                    <tr>
                                        <td>Durabiotic</td>
                                        <td>
                                             <asp:RadioButtonList ID="rdbDurabiotic" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                                    </tr>

                                </table>
                                
                              
                                  </td>
                            <td class="GridViewLabItemStyle"   colspan="2"    >Last Given&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

                                         <asp:TextBox ID="txtLast" CssClass="" runat="server"  Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtLast"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>
                           
                           

                            </td>
                                 </tr>
                                 <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >Drug Allergies

                            </td>
                                     <td class="GridViewLabItemStyle"   colspan="2"    >
                                          <asp:TextBox ID="txtDrug" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                              </td>
                                 </tr>
                        <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >PMHx 

                            </td>
                                     <td class="GridViewLabItemStyle"   colspan="2"    >
                                          <asp:TextBox ID="txtPMHx" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                              </td>
                                 </tr>
                                 <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >FHx 

                            </td>
                                     <td class="GridViewLabItemStyle"   colspan="2"    >
                                          <asp:TextBox ID="txtFHx" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                              </td>
                                 </tr>
                                 
                                 <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >SH

                            </td>
                                     <td class="GridViewLabItemStyle"   colspan="2"    >
                                          <asp:TextBox ID="txtSH" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                              </td>
                                 </tr>
                                <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >ROS

                            </td>
                                     <td class="GridViewLabItemStyle"   colspan="2"    >
                                          <asp:TextBox ID="txtROS" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                              </td>
                                 </tr>
                                 
                                <tr>
                                     
                            <th class="GridViewLabItemStyle" style="background-color:gray;color:white;text-align:left;"  colspan="3"    >Physical Examination</th>
                                    </tr>
                                 
                                 <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="3" >
                                <table style="width:100%;">
                                    <tr>
                                        
                            <td  >
                                HR

                            </td>
                                     <td    >
                                          <asp:TextBox ID="txtHR" CssClass="" runat="server"  width="80px"  ClientIDMode="Static" ></asp:TextBox>
                              </td>
                                       
                            <td >RR

                            </td>
                                     <td     >
                                          <asp:TextBox ID="txtRR" CssClass="" runat="server"   width="80px"   ClientIDMode="Static" ></asp:TextBox>
                                         </td>
                                        
                            <td >BP

                            </td>
                                     <td     >
                                          <asp:TextBox ID="txtBP" CssClass="" runat="server"  width="80px"    ClientIDMode="Static" ></asp:TextBox>
                                         </td>
                                        
                            <td >SAT

                            </td>
                                     <td     >
                                          <asp:TextBox ID="txtSAT" CssClass="" runat="server"  width="80px"    ClientIDMode="Static" ></asp:TextBox>
                                         </td>
                                        
                            <td >Temp

                            </td>
                                     <td     >
                                          <asp:TextBox ID="txtTemp" CssClass="" runat="server"  width="80px"    ClientIDMode="Static" ></asp:TextBox>
                                         </td>
                                     </tr>
                                     </table>
                        </td>
                                     </tr>
                                  <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >General

                            </td>
                                     <td class="GridViewLabItemStyle"   colspan="2"    >
                                          <asp:TextBox ID="txtGeneral" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                              </td>
                                 </tr>
                                 <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >Heart

                            </td>
                                     <td class="GridViewLabItemStyle"   colspan="2"    >
                                          <asp:TextBox ID="txtHeart" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                              </td>
                                 </tr>
                                 
                                 <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >Lungs

                            </td>
                                     <td class="GridViewLabItemStyle"   colspan="2"    >
                                          <asp:TextBox ID="txtLungs" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                              </td>
                                 </tr>
                                 
                                 <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >Abdomen

                            </td>
                                     <td class="GridViewLabItemStyle"   colspan="2"    >
                                          <asp:TextBox ID="txtAbdomen" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                              </td>
                                 </tr>
                                 
                                 <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >Extremities

                            </td>
                                     <td class="GridViewLabItemStyle"   colspan="2"    >
                                          <asp:TextBox ID="txtExtremities" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                              </td>
                                 </tr>
                                 
                                 <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >Chest X-ray findings

                            </td>
                                     <td class="GridViewLabItemStyle"   colspan="2"    >
                                          <asp:TextBox ID="txtChest" CssClass="" runat="server"   TextMode="MultiLine"    ClientIDMode="Static" ></asp:TextBox>
                              </td>
                                 </tr>
                                 
                                 <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >Laboratory Investigation

                            </td>
                                     <td class="GridViewLabItemStyle"   colspan="2"    >
                                          <asp:TextBox ID="txtLaboratory" CssClass="" runat="server"   TextMode="MultiLine"    ClientIDMode="Static" ></asp:TextBox>
                              </td>
                                 </tr>
                                 
                                 <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >ECG Findings

                            </td>
                                     <td class="GridViewLabItemStyle"   colspan="2"    >
                                          <asp:TextBox ID="txtECG" CssClass="" runat="server"   TextMode="MultiLine"    ClientIDMode="Static" ></asp:TextBox>
                              </td>
                                 </tr>
                                 
                                 <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >Indication For ECHO

                            </td>
                                     <td class="GridViewLabItemStyle"   colspan="2"    >
                                          <asp:TextBox ID="txtIndication" CssClass="" runat="server"   TextMode="MultiLine"    ClientIDMode="Static" ></asp:TextBox>
                              </td>
                                 </tr>
                                
                                 <tr>
                                     
                            <th class="GridViewLabItemStyle"   colspan="3" style="background-color:gray;color:white;text-align:left;"   >Echocardiogram Report

                            </th>
                               </tr>
                                 
                                 <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >SONO

                            </td>
                                     <td class="GridViewLabItemStyle"   colspan="2"    >
                                         <asp:DropDownList id="ddlSONO" runat="server" Width="200px">
                                        </asp:DropDownList></td>
                                 </tr>
                                  <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="3"    >
                                <table style="width:100%;">
                                    <tr>
                                        
                                     <td   >LA
                            </td>
                                     <td   >
                                          <asp:TextBox ID="txtLA" CssClass="" runat="server" width="80px"   ClientIDMode="Static" ></asp:TextBox>
                                         </td>
                                      
                                     <td   >LV
                            </td>
                                     <td   >
                                          <asp:TextBox ID="txtLV" CssClass="" runat="server"  width="80px"    ClientIDMode="Static" ></asp:TextBox>
                                         </td>
                              </tr></table>
                                     </td>
                                 </tr>
                                 
                                  <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="3"    >
                                <table style="width:100%;">
                                    <tr>
                                        
                                     <td   >LVd(cm)
                            </td>
                                     <td   >
                                          <asp:TextBox ID="txtLVd" CssClass="" runat="server" width="80px"   ClientIDMode="Static" ></asp:TextBox>
                                         </td>
                                      
                                     <td   >LVs(cm)
                            </td>
                                     <td   >
                                          <asp:TextBox ID="txtLVs" CssClass="" runat="server"  width="80px"    ClientIDMode="Static" ></asp:TextBox>
                                         </td>
                                        
                                     <td   >SF/EF
                            </td>
                                     <td   >
                                          <asp:TextBox ID="txtSF" CssClass="" runat="server" width="80px"   ClientIDMode="Static" ></asp:TextBox>
                                         /
                                          <asp:TextBox ID="txtEF" CssClass="" runat="server"  width="80px"    ClientIDMode="Static" ></asp:TextBox>
                                         </td>
                             
                              </tr></table>
                                     </td>
                                 </tr>
                                  <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="3"    >
                                <table style="width:100%;">
                                    <tr>
                                        
                                     <td   >RA
                            </td>
                                     <td   >
                                          <asp:TextBox ID="txtRA" CssClass="" runat="server" width="80px"   ClientIDMode="Static" ></asp:TextBox>
                                         </td>
                                      
                                     <td   >RV
                            </td>
                                     <td   >
                                          <asp:TextBox ID="txtRV" CssClass="" runat="server"  width="80px"    ClientIDMode="Static" ></asp:TextBox>
                                         </td>
                              </tr></table>
                                     </td>
                                 </tr>
                                 
                                  <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >AV
                                </td>
                                <td class="GridViewLabItemStyle"   colspan="2"    >
                                     <asp:TextBox ID="txtAV" CssClass="" runat="server"      ClientIDMode="Static" ></asp:TextBox>
                                         
                                </td>
                                      </tr>
                                 
                                  <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >MV
                                </td>
                                <td class="GridViewLabItemStyle"   colspan="2"    >
                                     <asp:TextBox ID="txtMV" CssClass="" runat="server"      ClientIDMode="Static" ></asp:TextBox>
                                         
                                </td>
                                      </tr>
                                 
                                  <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >TV
                                </td>
                                <td class="GridViewLabItemStyle"   colspan="2"    >
                                     <asp:TextBox ID="txtTV" CssClass="" runat="server"      ClientIDMode="Static" ></asp:TextBox>
                                         
                                </td>
                                      </tr>
                                 
                                  <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >PV
                                </td>
                                <td class="GridViewLabItemStyle"   colspan="2"    >
                                     <asp:TextBox ID="txtPV" CssClass="" runat="server"      ClientIDMode="Static" ></asp:TextBox>
                                         
                                </td>
                                      </tr>
                                 
                                  <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >Pericardium
                                </td>
                                <td class="GridViewLabItemStyle"   colspan="2"    >
                                     <asp:TextBox ID="txtPevicardium" CssClass="" runat="server"      ClientIDMode="Static" ></asp:TextBox>
                                         
                                </td>
                                      </tr>
                                 
                                  <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >Aorta
                                </td>
                                <td class="GridViewLabItemStyle"   colspan="2"    >
                                     <asp:TextBox ID="txtAorta" CssClass="" runat="server"      ClientIDMode="Static" ></asp:TextBox>
                                         
                                </td>
                                      </tr>
                                 
                                  <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >PAs
                                </td>
                                <td class="GridViewLabItemStyle"   colspan="2"    >
                                     <asp:TextBox ID="txtPAs" CssClass="" runat="server"      ClientIDMode="Static" ></asp:TextBox>
                                         
                                </td>
                                      </tr>
                                 
                                  <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >PDA
                                </td>
                                <td class="GridViewLabItemStyle"   colspan="2"    >
                                     <asp:TextBox ID="txtPDA" CssClass="" runat="server"      ClientIDMode="Static" ></asp:TextBox>
                                         
                                </td>
                                      </tr>
                                 
                                  <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >A Sept
                                </td>
                                <td class="GridViewLabItemStyle"   colspan="2"    >
                                     <asp:TextBox ID="txtASept" CssClass="" runat="server"      ClientIDMode="Static" ></asp:TextBox>
                                         
                                </td>
                                      </tr>
                                 
                                  <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >V Sept
                                </td>
                                <td class="GridViewLabItemStyle"   colspan="2"    >
                                     <asp:TextBox ID="txtVSept" CssClass="" runat="server"      ClientIDMode="Static" ></asp:TextBox>
                                         
                                </td>
                                      </tr>
                                 
                                  <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >Sys vv
                                </td>
                                <td class="GridViewLabItemStyle"   colspan="2"    >
                                     <asp:TextBox ID="txtSysvv" CssClass="" runat="server"      ClientIDMode="Static" ></asp:TextBox>
                                         
                                </td>
                                      </tr>
                                 
                                  <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >Pulm vv
                                </td>
                                <td class="GridViewLabItemStyle"   colspan="2"    >
                                     <asp:TextBox ID="txtPulmvv" CssClass="" runat="server"      ClientIDMode="Static" ></asp:TextBox>
                                         
                                </td>
                                      </tr>
                                 
                                  <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="3"    >
                                <table style="width:100%;">
                                    <tr>
                                        <td>Annular Size</td>
                                        <td>Mitral</td>
                                        <td><asp:TextBox ID="txtMitral" CssClass="" runat="server" width="80px"     ClientIDMode="Static" ></asp:TextBox>
                                     </td>
                                        <td>Aortic</td>
                                        <td><asp:TextBox ID="txtAortic" CssClass="" runat="server" width="80px"     ClientIDMode="Static" ></asp:TextBox>
                                     </td>
                                        
                                        <td>Tricuspid</td>
                                        <td><asp:TextBox ID="txtTricuspid" CssClass="" runat="server" width="80px"     ClientIDMode="Static" ></asp:TextBox>
                                     </td>
                                    </tr>
                                </table>
                                </td>
                                      </tr>
                            
                                  <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >Impression</td>
                                      
                            <td class="GridViewLabItemStyle"   colspan="2"    ><asp:TextBox ID="txtImpression" CssClass="" runat="server" TextMode="MultiLine"    ClientIDMode="Static" ></asp:TextBox>
                                     </td>
                                      </tr>
                                 
                                  <tr>
                                     
                            <td class="GridViewLabItemStyle"   colspan="1"    >Plan</td>
                                      
                            <td class="GridViewLabItemStyle"   colspan="2"    ><asp:TextBox ID="txtPlan" CssClass="" runat="server" TextMode="MultiLine"    ClientIDMode="Static" ></asp:TextBox>
                                     </td>
                                      </tr>
                                 </table>
                   
                        </div>
                    </div>
                      </div>
 
            
                
            
            <div class="POuter_Box_Inventory" style="text-align: center">
                
                                                <asp:Label ID="lblID"  runat="server" Visible="FALSE"></asp:Label>
                <asp:Button ID="btnSave" ClientIDMode="Static" runat="server" OnClick="btnSave_Click" Text="save" CssClass="ItDoseButton"  OnClientClick="return validate();"   />
                <asp:Button ID="btnUpdate" ClientIDMode="Static" runat="server" Text="Update" Visible="false" CssClass="ItDoseButton" TabIndex="69" OnClientClick="return validate();" OnClick="btnUpdate_Click" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="ItDoseButton" TabIndex="69" Visible="false" OnClick="btnCancel_Click" />
               <%--  <asp:Button ID="btnPrint" runat="server" Text="Print" CssClass="ItDoseButton" TabIndex="69" OnClick="btnPrint_Click" />
            
              <input type="button" value="Save" id="btnSave" title="Save All Details" onclick="SaveData();" />--%>
            </div>
                 
             <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:GridView ID="grdPhysical" Visible="true" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowCommand="grdPhysical_RowCommand" OnRowDataBound="grdPhysical_RowDataBound" TabIndex="6">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="UHID">
                            <ItemTemplate>
                                <asp:Label ID="lblPatientID1" runat="server" Text='<%# Eval("PatientID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Type">
                            <ItemTemplate>
                                <asp:Label ID="lblType" runat="server" Text='<%# Eval("Type1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        
                        
                        <asp:TemplateField HeaderText="IPDNo/EncounterNo">
                            <ItemTemplate>
                                <asp:Label ID="lblEncounterNo" runat="server" Text='<%# Eval("EncounterNo1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                          <asp:TemplateField HeaderText="Transaction ID" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblPatientID" runat="server" Text='<%# Eval("TransactionID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Entry By" Visible="true">
                            <ItemTemplate>
                                <asp:Label ID="lblEntry" runat="server" Text='<%#Eval("EmpName") %>'></asp:Label>
                                <asp:Label ID="lblCreatedID" runat="server" Text='<%#Eval("CreatedBy") %>' Visible="false"></asp:Label>
                                
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date">
                            <ItemTemplate>
                                <asp:Label ID="lblDate" runat="server" Text='<%#Eval("Date1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Time">
                            <ItemTemplate>
                                <asp:Label ID="lblTime" runat="server" Text='<%#Eval("Time1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Edit" >
                            <ItemTemplate>
                                 <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/edit.png" runat="server" />
                                                <asp:Label ID="lblUserID" Text='<%#Eval("CreatedBy") %>' runat="server" Visible="false"></asp:Label>
                                                <asp:Label ID="lblID" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                                                
                                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="60" />
                        </asp:TemplateField>
                    <asp:TemplateField HeaderText="Print">
                            <ItemTemplate>
                                 <asp:ImageButton ID="imgbtnEdit1" AlternateText="Edit" CommandName="Print" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/print.gif" runat="server" />
                                                <asp:Label ID="lblID1" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                                                
                                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  Width="60" />
                        </asp:TemplateField>
                    
                    </Columns>
                </asp:GridView>
            </div>
             
         
        </div>
    </form>

</body>
</html>


