<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ICUShiftForm.aspx.cs" Inherits="Design_IPD_ICUShiftForm" %>

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
        .col-md-16 {
              display: flex;
            }
        .col-md-16 > div {
                  border: 1px solid black;
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
        $(document).ready(function () {
            $("#spnPatientID").text('<%=Request.QueryString["PID"].ToString() %>');
            $("#spnTransactionID").text('<%=Request.QueryString["TID"].ToString() %>');
            $("#ddlIsolation").change(function () {
                if ($("#ddlIsolation").val() == "1") {
                    $("#txtIsolationDetails").show();
                }
                else {
                    $("#txtIsolationDetails").hide();
                }
            });
                   });

        function validate() {
            if ($('#txtFacial').val() == "" && $('#txtCry').val() == "" && $('#txtBreathing').val() == "" && $('#txtArms').val() == "" && $('#txtLegs').val() == "" && $('#txtState').val() == "" && $('#txtTotal').val() == "" && $('#txtAction').val() == "") {
                modelAlert("Please Fill Details.", function () { });
                return false;
            }
        }

    </script>

    <form id="form2" runat="server">
        
        <div class="POuter_Box_Inventory" style="text-align: center;">
             <b>ICU Shift Form </b>
                <br />
            
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
           <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
               <div class="Purchaseheader" style="text-align: left;">
                   ICU Shift Form
                </div>
 </div>
        
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="row">
                    <div class="col-md-2" >Date
                        </div>
                     <div class="col-md-5">
                          <span  style="display:none;"  id="spnTransactionID"></span>
                   
                        <span style="display:none;" id="spnPatientID"></span>
                        
                        <span  style="display:none;"  id="spnEditPatientNote"></span>
                         
                                <asp:Label ID="lblID" runat="server" Visible="false"></asp:Label>
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
                        <table style="width:100%;"  >
                            
                            <tr>
                                <td >DX</td>
                                <td >
                                    <asp:TextBox ID="txtDX" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                <td >HX</td>
                                <td >
                                    <asp:TextBox ID="txtHX" CssClass="" runat="server"  ClientIDMode="Static" ></asp:TextBox>
                                    
                                </td>
                                <td >Allergies</td>
                                <td >
                                    <asp:TextBox ID="txtAllergies" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                </tr>
                            
                            <tr>
                            
                                <td >Code</td>
                                <td >
                                     <asp:DropDownList id="ddlCode" runat="server">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                    
                                </td>
                                <td >Isolation</td>
                                <td >
                                     <asp:DropDownList id="ddlIsolation" runat="server" >
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                    
                                </td>
                                <td >
                                    <asp:TextBox ID="txtIsolationDetails" CssClass="" runat="server"   ClientIDMode="Static"  style="display:none;" ></asp:TextBox>
                                    
                                     </td>
                                <td >
                                    </td>
                                
                            </tr>
                            <tr style="background-color:royalblue;color:white;">
                                <td colspan="6">
                                    Neuro
                                </td>
                            </tr>
                           
                            <tr>
                                <td >LOC</td>
                                <td >
                                    <asp:TextBox ID="txtLOC" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                <td >Pupils</td>
                                <td >
                                     <asp:TextBox ID="txtPupils" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                                <td >MS/Ability to Move</td>
                                <td >
                                    <asp:TextBox ID="txtMS" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                </tr>
                           
                            <tr>
                            
                                <td >GCS</td>
                                <td >
                                     <asp:TextBox ID="txtGCS" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                            
                                <td >Activity</td>
                                <td >
                                    <asp:TextBox ID="txtActivity" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                <td >Sleep</td>
                                <td >
                                     <asp:TextBox ID="txtSleep" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                            </tr>
                             <tr>
                                <td >Pain Y/N Loc</td>
                                <td >
                                    <asp:TextBox ID="txtPain" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                <td >Sedation/Drains</td>
                                <td >
                                     <asp:TextBox ID="txtSedation" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                            
                                <td >Follow Up</td>
                                <td >
                                    <asp:TextBox ID="txtFollowUp1" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                
                                                             </tr>
                            <tr style="background-color:royalblue;color:white;">
                                <td colspan="6">
                                    CVS
                                </td>
                            </tr>
                            
                             <tr>
                                <td >ECG Rhythm</td>
                                <td >
                                    <asp:TextBox ID="txtECGRhythm" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                <td >
                                    SIS2
                                </td>
                                <td >
                                      <asp:TextBox ID="txtSIS2" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                   
                                </td>
                            
                                <td >BP Cuff</td>
                                <td >
                                    <asp:TextBox ID="txtBPCuff" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                 </tr>
                            <tr>
                                <td >
                                    NBP
                                </td>
                                <td >
                                      <asp:TextBox ID="txtNHP" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                   
                                </td>
                            
                                <td >ART Line </td>
                                <td >
                                    <asp:TextBox ID="txtArtLine" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                
                                <td >Support  </td>
                                <td >
                                    <asp:TextBox ID="txtSupport" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                </tr>
                            <tr>
                                <td >
                                    PY/N
                                </td>
                                <td >
                                     <asp:TextBox ID="txtPYN" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                            
                                <td >Anti Cog  </td>
                                <td >
                                    <asp:TextBox ID="txtAntiCog" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                <td >
                                    K+
                                </td>
                                <td >
                                     <asp:TextBox ID="txtKPlus" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                            </tr>
                            
                            <tr>
                                <td >CVP  </td>
                                <td >
                                    <asp:TextBox ID="txtCVP" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                <td >
                                    PPulse
                                </td>
                                <td >
                                     <asp:TextBox ID="txtPPulse" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                            
                                <td >Cap Refill  </td>
                                <td >
                                    <asp:TextBox ID="txtCapRefill" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                </tr>
                            
                            <tr>
                                <td >
                                    Skin
                                </td>
                                <td >
                                     <asp:TextBox ID="txtSkin" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                            
                                <td >Edema  </td>
                                <td >
                                    <asp:TextBox ID="txtEdema" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                <td >
                                    CVC Site
                                </td>
                                <td >
                                     <asp:TextBox ID="txtCVCSite" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                            </tr>
                           <tr>
                                <td >Pros  </td>
                                <td >
                                    <asp:TextBox ID="txtPros" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                <td >
                                    Due
                                </td>
                                <td >
                                     <asp:TextBox ID="txtDue" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                            
                                <td >Med  </td>
                                <td >
                                    <asp:TextBox ID="txtMed" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                               </tr>
                           <tr>
                                <td >
                                    Due
                                </td>
                                <td >
                                     <asp:TextBox ID="txtDue1" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                            
                                <td >Dist  </td>
                                <td >
                                    <asp:TextBox ID="txtDist" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                <td >
                                    Due
                                </td>
                                <td >
                                     <asp:TextBox ID="txtDue2" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                            </tr>
                           <tr>
                                <td >Perish IV Soln  </td>
                                <td >
                                    <asp:TextBox ID="txtPerishIVSoln" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                <td >
                                    Rate
                                </td>
                                <td >
                                     <asp:TextBox ID="txtRate" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                                <td >Soln  </td>
                                <td >
                                    <asp:TextBox ID="txtSoln" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                </tr>
                           <tr>
                           
                                <td >
                                    Rate
                                </td>
                                <td >
                                     <asp:TextBox ID="txtRate1" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                                <td >Dressing/Drains  </td>
                                <td >
                                    <asp:TextBox ID="txtDingsDrain" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                <td >
                                    FollowUp
                                </td>
                                <td >
                                     <asp:TextBox ID="txtFollowUp2" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                            </tr>
                           <tr style="background-color:royalblue;color:white;">
                               <td colspan="6">
                                   RESP
                               </td>
                           </tr>
                            
                           <tr>
                                <td >RR  </td>
                                <td >
                                    <asp:TextBox ID="txtRR" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                <td >
                                    Breath sounds
                                </td>
                                <td >
                                     <asp:TextBox ID="txtBreathSed" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                            
                                <td >O2 TX  </td>
                                <td >
                                    <asp:TextBox ID="txtO2TX" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                               </tr>
                            
                           <tr>
                                <td >
                                    O2 Sats 
                                </td>
                                <td >
                                     <asp:TextBox ID="txtO2Nat" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                            
                                <td >Type Airway  </td>
                                <td >
                                    <asp:TextBox ID="txtTypeAirway" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                <td >
                                    Cuff Press 
                                </td>
                                <td >
                                     <asp:TextBox ID="txtCuffPress" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                            </tr>
                            
                             <tr>
                                <td >Lip Mark   </td>
                                <td >
                                    <asp:TextBox ID="txtLipMark" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                <td >
                                    Vent Mode 
                                </td>
                                <td >
                                     <asp:TextBox ID="txtVentMode" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                            
                                <td >RR    </td>
                                <td >
                                    <asp:TextBox ID="txtRR1" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                 </tr>
                            
                             <tr>
                                <td >
                                    TV  
                                </td>
                                <td >
                                     <asp:TextBox ID="txtTV" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                         
                                <td >FIO2    </td>
                                <td >
                                    <asp:TextBox ID="txtFIO2" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                <td >
                                    PEEP  
                                </td>
                                <td >
                                     <asp:TextBox ID="txtPEEP" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                            </tr>
                             
                             <tr>
                                <td >PS    </td>
                                <td >
                                    <asp:TextBox ID="txtPS" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                <td >
                                    MV  
                                </td>
                                <td >
                                     <asp:TextBox ID="txtMV" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                                <td >Airway Press    </td>
                                <td >
                                    <asp:TextBox ID="txtAirwayPress" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                 </tr>
                          <tr>
                            
                                <td >
                                    ABGS  
                                </td>
                                <td >
                                     <asp:TextBox ID="txtABGS" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                            
                                <td >Secretions    </td>
                                <td >
                                    <asp:TextBox ID="txtSecreation" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                <td >
                                    Suction  
                                </td>
                                <td >
                                     <asp:TextBox ID="txtSuction" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                            </tr>
                          <tr>
                                <td >Dressing Drain    </td>
                                <td >
                                    <asp:TextBox ID="txtDingsDrain1" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                <td >
                                    FollowUp  
                                </td>
                                <td >
                                    <asp:TextBox ID="txtFollowUp3" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                              <td></td>
                              <td></td>
                            </tr>
                            
                          <tr style="background-color:royalblue;color:white;">
                              <td colspan="6">
                                  GI
                              </td>
                          </tr>
                          <tr>
                                <td >Diet    </td>
                                <td >
                                    <asp:TextBox ID="txtDiet" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                <td >
                                    NG  
                                </td>
                                <td >
                                    <asp:TextBox ID="txtNG" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                                <td >Abd    </td>
                                <td >
                                    <asp:TextBox ID="txtAbd" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                              </tr>
                            
                          <tr>
                            
                                <td >
                                    BS  
                                </td>
                                <td >
                                    <asp:TextBox ID="txtBS" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                            
                                <td >Last BM    </td>
                                <td >
                                    <asp:TextBox ID="txtLastBM" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                <td >
                                    BSugar  
                                </td>
                                <td >
                                    <asp:TextBox ID="txtBSugar" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                            </tr>
                            
                            <tr>
                                <td >Insulin    </td>
                                <td >
                                    <asp:TextBox ID="txtInsulin" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                <td >
                                    Dressing drains  
                                </td>
                                <td >
                                    <asp:TextBox ID="txtDingsDrains1" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                            
                                <td >Anti Ulcer Rx    </td>
                                <td >
                                    <asp:TextBox ID="txtAntiUlcerRx" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                </tr>
                            
                            <tr>
                                <td >
                                    Follow Up  
                                </td>
                                <td >
                                    <asp:TextBox ID="txtFollowUp4" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                            
                            <tr style="background-color:royalblue;color:white;">
                                <td colspan="6">
                                    GU
                                </td>
                            </tr>
                          
                            <tr>
                                <td >Foley Y/N Hrly    </td>
                                <td >
                                    <asp:TextBox ID="txtFoleyYNHrly" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                <td >
                                    U/O Up  
                                </td>
                                <td >
                                    <asp:TextBox ID="txtUO" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                                <td >Urine    </td>
                                <td >
                                    <asp:TextBox ID="txtUrine" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                </tr>
                            <tr>
                            
                                <td >
                                    BUN/CR  
                                </td>
                                <td >
                                    <asp:TextBox ID="txtBUNCR" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                                <td >24 HR Bal    </td>
                                <td >
                                    <asp:TextBox ID="txt24HRBal" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                <td >
                                    Shift  
                                </td>
                                <td >
                                    <asp:TextBox ID="txtShift" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                            </tr>
                            <tr>
                                <td > Bal    </td>
                                <td >
                                    <asp:TextBox ID="txtBal" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                <td >
                                    Dialysis  
                                </td>
                                <td >
                                    <asp:TextBox ID="txtDialysis" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                            
                                <td > Follow Up    </td>
                                <td >
                                    <asp:TextBox ID="txtFollowUp5" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                </tr>
                            
                            
                            <tr style="background-color:royalblue;color:white;">
                                <td colspan="6">
                                    Skin
                                </td>
                            </tr>
                            <tr>
                                <td > Temp    </td>
                                <td >
                                    <asp:TextBox ID="txtTemp" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                <td >
                                      WBC
                                </td>
                                <td >
                                    <asp:TextBox ID="txtWBC" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                           
                                <td > Intact Y/N    </td>
                                <td >
                                    <asp:TextBox ID="txtIntactYN" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                 </tr>
                            <tr>
                                <td >
                                      Ding Changes
                                </td>
                                <td >
                                    <asp:TextBox ID="txtDingChanges" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                                <td > Other    </td>
                                <td >
                                    <asp:TextBox ID="txtOther" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    </td>
                                <td >
                                       Created By
                                </td>
                                <td >
                                    <asp:TextBox ID="txtCreatedBy" CssClass="" runat="server"   ClientIDMode="Static"   ></asp:TextBox>
                                    
                                </td>
                            </tr>
                            </table>
                        
                        
                        
                        
                    </div>
                </div>
               
               
               
               
                
                </div>
                
            <div class="POuter_Box_Inventory" style="text-align: center;">

            
            <div class="POuter_Box_Inventory" style="text-align: center">
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
                        <asp:TemplateField HeaderText="DX">
                            <ItemTemplate>
                                <asp:Label ID="lblDX" runat="server" Text='<%#Eval("DX") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="HX ">
                            <ItemTemplate>
                                <asp:Label ID="lblHX" runat="server" Text='<%#Eval("HX") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Code1">
                            <ItemTemplate>
                                <asp:Label ID="lblCode" runat="server" Text='<%#Eval("Code1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Isolation">
                            <ItemTemplate>
                                <asp:Label ID="lblIsolation" runat="server" Text='<%#Eval("Isolation1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="LOC ">
                            <ItemTemplate>
                                <asp:Label ID="lblLOC" runat="server" Text='<%#Eval("LOC") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Pupils">
                            <ItemTemplate>
                                <asp:Label ID="lblPupils" runat="server" Text='<%#Eval("Pupils") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="MS" >
                            <ItemTemplate>
                                <asp:Label ID="lblMS" runat="server" Text='<%#Eval("MS") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="GCS" >
                            <ItemTemplate>
                                <asp:Label ID="lblGCS" runat="server" Text='<%#Eval("GCS") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="UHID">
                            <ItemTemplate>
                                <asp:Label ID="lblPatientID1" runat="server" Text='<%# Eval("PatientID") %>'></asp:Label>
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
                        <asp:TemplateField HeaderText="Entry By" Visible="false">
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
                        
                      <%--  <asp:TemplateField HeaderText="Edit" >
                            <ItemTemplate>
                                 <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/edit.png" runat="server" />
                                                <asp:Label ID="lblUserID" Text='<%#Eval("CreatedBy") %>' runat="server" Visible="false"></asp:Label>
                                                <asp:Label ID="lblID" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                                                <asp:Label ID="lblTimeDiff" Text='<%#Eval("createdDateDiff") %>' runat="server" Visible="false"></asp:Label>  
                                            
                                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="60" />
                        </asp:TemplateField>
                    --%><asp:TemplateField HeaderText="Print">
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


