<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ObstetricAdmissionNote.aspx.cs" Inherits="Design_ip_ObstetricAdmissionNote" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/Time.ascx" TagName="StartTime" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>   
    <script type="text/javascript" src="../../Scripts/shortcut.js"></script>
    <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css" />
     <script type="text/javascript">
          </script>
    <style type="text/css">
        .col-md-3 {
        
       text-align:left;
        }
        label {
       text-align:left;
             }
    </style>

       
     

             

        
 
    <form id="form1" runat="server">
    
        <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>Obstetric Admission Notes</b>
                <br/>
               <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label>
               
            </div>
             <div class="POuter_Box_Inventory" style="text-align: left;">
                  <div class="Purchaseheader">
                <b>Obstetric History</b>             
            </div></div>
            <div class="POuter_Box_Inventory">
                                <div class="row">
                                    <div class="col-md-24">
                                        <div class="col-md-3">
                         <label class="pull-left">Date/Time</label>
                         <b class="pull-left">:</b>
                        </div> 
                        
                    <div class="col-md-2">
                                <asp:TextBox ID="txtDate" runat="server"  CssClass="disable_future_dates" 
                                ToolTip="Click To Select Date" Width="130px" TabIndex="1"  
                                ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender7" runat="server" TargetControlID="txtDate"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                            
                     </div>
                         <div class="col-md-4">
                                <%-- <asp:TextBox ID="txtTime" TabIndex="6" runat="server" Width="100px" placeholder="hh:mm(AM|PM)"></asp:TextBox>
                            <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time" TargetControlID="txtTime" AcceptAMPM="True"></cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator ID="maskTimeStart" runat="server" ControlToValidate="txtTime" ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Please Enter Time" InvalidValueMessage="Invalid Time ON" ForeColor="Red" Display="None"></cc1:MaskedEditValidator>
                        --%>
                             
                            <uc2:StartTime ID="StartTime" runat="server" />
                         </div>
                 
                                    </div>
                                </div>
                        <div class="row">
                            <div class="col-md-24">              
                             <div class="col-md-3"><label class="pull-left">Grav </label><b class="pull-left "> : </b></div>
                             <div class="col-md-5">
                                 
                                <asp:TextBox ID="txtGrav" runat="server"    ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender17" runat="server" TargetControlID="txtGrav" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                             <div class="col-md-3"> <label class="pull-left"> P </label><b class="pull-left ">: </b></div>
                             <div class="col-md-5">
                                 
                                <asp:TextBox ID="txtP" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtP" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                             <div class="col-md-2"> <label class="pull-left"> + </label></div>
                             <div class="col-md-5">
                                 
                                <asp:TextBox ID="txtPlus" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtPlus" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                             <div class="col-md-3"><label class="pull-left"> Living</label><b class="pull-left ">: </b></div>
                             <div class="col-md-5">
                                 
                                <asp:TextBox ID="txtLiving" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtLiving" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                              <div class="col-md-3"><label class="pull-left"> Dead </label><b class="pull-left ">: </b></div>
                             <div class="col-md-5">
                                 
                                <asp:TextBox ID="txtDead" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" TargetControlID="txtDead" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                           </div>
                           </div>
                 <div class="row">
                            <div class="col-md-24">              
                             <div class="col-md-3"><label class="pull-left">LMP </label><b class="pull-left "> : </b></div>
                             <div class="col-md-5">
                                 
                                <asp:TextBox ID="txtLMP" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" TargetControlID="txtLMP" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                             <div class="col-md-3"> <label class="pull-left"> EDD </label><b class="pull-left ">: </b></div>
                             <div class="col-md-5">
                                 
                                <asp:TextBox ID="txtEDD" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender6" runat="server" TargetControlID="txtEDD" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                             <div class="col-md-2"> <label class="pull-left"> Gestation </label><b class="pull-left ">: </b></div>
                             <div class="col-md-5">
                                 
                                <asp:TextBox ID="txtGestation" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender7" runat="server" TargetControlID="txtGestation" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                             <div class="col-md-3"><label class="pull-left"> Wks</label><b class="pull-left ">: </b></div>
                             <div class="col-md-5">
                                 
                                <asp:TextBox ID="txtWks" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender8" runat="server" TargetControlID="txtWks" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                              <div class="col-md-3"><label class="pull-left"> Days </label><b class="pull-left ">: </b></div>
                             <div class="col-md-5">
                                 
                                <asp:TextBox ID="txtDays" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender9" runat="server" TargetControlID="txtDays" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                           </div>
                           </div>
                 <div class="row">
                            <div class="col-md-24">              
                             <div class="col-md-3"><label class="pull-left">Anenatalcare </label><b class="pull-left "> : </b></div>
                             <div class="col-md-5">
                                 
                                <asp:TextBox ID="txtAnenatalcare" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender10" runat="server" TargetControlID="txtAnenatalcare" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                             <div class="col-md-3"> <label class="pull-left"> Visit Where </label><b class="pull-left ">: </b></div>
                             <div class="col-md-5">
                                 
                                <asp:TextBox ID="txtVisitWhere" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender11" runat="server" TargetControlID="txtVisitWhere" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                    </div></div>
                <div class="row">
                            <div class="col-md-24">              
                             <div class="col-md-3"><label class="pull-left">Hospital Deliveries </label><b class="pull-left "> : </b></div>
                             <div class="col-md-5">
                                 
                                <asp:TextBox ID="txtHospitalDeliveries" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender12" runat="server" TargetControlID="txtHospitalDeliveries" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                             <div class="col-md-3"> <label class="pull-left"> Caesrean Section </label><b class="pull-left ">: </b></div>
                             <div class="col-md-5">
                                <asp:TextBox ID="txtCaesreanSection" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender13" runat="server" TargetControlID="txtCaesreanSection" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>

                             </div>
                             <div class="col-md-2"> <label class="pull-left"> VBACS </label><b class="pull-left ">: </b></div>
                             <div class="col-md-5">
                                 
                                <asp:TextBox ID="txtVBACS" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender14" runat="server" TargetControlID="txtVBACS" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                </div></div>
                 <div class="row">
                            <div class="col-md-24">              
                             <div class="col-md-3"><label class="pull-left">APH </label><b class="pull-left "> : </b></div>
                             <div class="col-md-5">
                                 
                                <asp:TextBox ID="txtAPH" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender15" runat="server" TargetControlID="txtAPH" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                             <div class="col-md-3"> <label class="pull-left"> PPH </label><b class="pull-left ">: </b></div>
                             <div class="col-md-5">
                                 
                                <asp:TextBox ID="txtPPH" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender16" runat="server" TargetControlID="txtPPH" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                             <div class="col-md-2"> <label class="pull-left"> PreEclamp </label><b class="pull-left ">: </b></div>
                             <div class="col-md-5">
                                 
                                <asp:TextBox ID="txtPreEclamp" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender18" runat="server" TargetControlID="txtPreEclamp" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                             <div class="col-md-3"> <label class="pull-left"> Stillbirth </label><b class="pull-left ">: </b></div>
                             <div class="col-md-5">
                                 
                                <asp:TextBox ID="txtStillbirth" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender19" runat="server" TargetControlID="txtStillbirth" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                                <div class="col-md-3"> <label class="pull-left"> Abortions/Miscarriages(less or=20wks)</label><b class="pull-left "></b></div>
                             <div class="col-md-5">
                                 
                                <asp:TextBox ID="txtAbortionsMiscarriages" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender21" runat="server" TargetControlID="txtAbortionsMiscarriages" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div> 
                                 <div class="col-md-2"> <label class="pull-left"> Family Planning awareness: </label><b class="pull-left "></b></div>
                             <div class="col-md-5"> <asp:RadioButtonList ID="rdbFamilyPlanningawareness" runat="server" RepeatDirection="Horizontal">
                              <asp:ListItem Value="Yes" Selected="True">Yes</asp:ListItem>
                              <asp:ListItem Value="No">No</asp:ListItem>
                          </asp:RadioButtonList>
                                
                                
                </div> </div>
                    <div class="row">
                            <div class="col-md-24">              
                             <div class="col-md-3"><label class="pull-left">Preterm (20 to 37 wks) </label><b class="pull-left "> : </b></div>
                             <div class="col-md-5">
                                 
                                <asp:TextBox ID="txtPreterm" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender20" runat="server" TargetControlID="txtPreterm" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                                 <div class="col-md-3"> <label class="pull-left"> Neonatal Jaundice </label><b class="pull-left ">: </b></div>
                             <div class="col-md-5">
                                 
                                <asp:TextBox ID="txtNeonatalJaundice" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender23" runat="server" TargetControlID="txtNeonatalJaundice" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                                <div class="col-md-2"> <label class="pull-left">Any FP Used </label><b class="pull-left ">: </b></div>
                             <div class="col-md-5"> <asp:RadioButtonList ID="rdbAnyFPUsed" runat="server" RepeatDirection="Horizontal">
                              <asp:ListItem Value="Yes" Selected="True">Yes</asp:ListItem>
                              <asp:ListItem Value="No">No</asp:ListItem>
                          </asp:RadioButtonList>
                                 </div>
                               
                                 
                             
                    </div></div>
                <div class="row">
                            <div class="col-md-24">              
                             <div class="col-md-3"><label class="pull-left">First week mortality </label><b class="pull-left "> : </b></div>
                             <div class="col-md-5">
                                 
                                <asp:TextBox ID="txtFirstweekmortality" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender22" runat="server" TargetControlID="txtFirstweekmortality" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                            
                            
                     </div>
                   </div>
                     <div class="row">
                            <div class="col-md-24">    
                                 
                              
                             <div class="col-md-3"><label class="pull-left">History labour began on date</label><b class="pull-left "> : </b></div>
                             <div class="col-md-2">
                                 
                                <asp:TextBox ID="txtHistoryoflabourbeganondate" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                  <cc1:CalendarExtender ID="caldate" runat="server" TargetControlID="txtHistoryoflabourbeganondate"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                             </div>
                             <div class="col-md-1"> <label class="pull-left"> At time </label><b class="pull-left "> : </b></div>
                             <div class="col-md-5">
                                 
                                
                            <uc2:StartTime ID="Attime" runat="server" />
                             </div>
                    </div></div>
                        <div class="row">
                            <div class="col-md-24 ">              
                             <div class="col-md-3"><label class="pull-left">ROM</label><b class="pull-left "> : </b></div>
                              <div class="col-md-2"><asp:RadioButtonList ID="rdbROM" runat="server" RepeatDirection="Horizontal">
                              <asp:ListItem Value="Yes" Selected="True">Yes</asp:ListItem>
                              <asp:ListItem Value="No">No</asp:ListItem></asp:RadioButtonList>

                              </div>
                             <div class="col-md-1+(1/2)"> <label class="pull-left"> If Yes, dates </label><b class="pull-left ">: </b></div>
                             <div class="col-md-3">
                                  <asp:TextBox ID="ROMdates" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="ROMdates"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                             </div>
                                 <div class="col-md-1"> <label class="pull-left"> at Time </label><b class="pull-left ">: </b></div>
                             <div class="col-md-6">
                                 
                                
                            <uc2:StartTime ID="ROMTime" runat="server" />
                             </div>
                                 <div class="col-md-2"> <label class="pull-left"> Colour of fluid </label><b class="pull-left ">: </b></div>
                             <div class="col-md-5">
                                 
                                <asp:TextBox ID="txtColouroffluid" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender27" runat="server" TargetControlID="txtColouroffluid" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                    </div></div><br />
                       </div>
                <div class="Purchaseheader" style="text-align: left;">
                <b>Medical History</b></div>
            </div>
                <div class="POuter_Box_Inventory" style="text-align: left;">                      
                        <div class="row">
                            <div class="col-md-24">              
                             <div class="col-md-3"><label class="pull-left"> Heart Disease </label><b class="pull-left ">: </b></div>
                             <div class="col-md-3"><asp:RadioButtonList ID="rdbHeartDisease" runat="server" RepeatDirection="Horizontal">
                              <asp:ListItem Value="Yes" Selected="True">Yes</asp:ListItem>
                              <asp:ListItem Value="No">No</asp:ListItem>
                                 
                          </asp:RadioButtonList>
                                 </div>
                                <div class="col-md-3"> <label class="pull-left"> Hypertension </label><b class="pull-left ">: </b></div>
                            <div class="col-md-3"> <asp:RadioButtonList ID="rdbHypertension" runat="server" RepeatDirection="Horizontal">
                              <asp:ListItem Value="Yes" Selected="True">Yes</asp:ListItem>
                              <asp:ListItem Value="No">No</asp:ListItem>
                          </asp:RadioButtonList>
                                </div>
                                <div class="col-md-3"> <label class="pull-left"> Kidney Disease </label><b class="pull-left ">: </b></div>
                             <div class="col-md-3"><asp:RadioButtonList ID="rdbKidneyDisease" runat="server" RepeatDirection="Horizontal">
                              <asp:ListItem Value="Yes" Selected="True">Yes</asp:ListItem>
                              <asp:ListItem Value="No">No</asp:ListItem>
                          </asp:RadioButtonList>
                                 </div>
                                <div class="col-md-3"> <label class="pull-left"> Diabetes </label><b class="pull-left ">: </b></div>
                             <div class="col-md-3"><asp:RadioButtonList ID="rdbDiabetes" runat="server" RepeatDirection="Horizontal">
                              <asp:ListItem Value="Yes" Selected="True">Yes</asp:ListItem>
                              <asp:ListItem Value="No">No</asp:ListItem>
                          </asp:RadioButtonList>
                                 </div>
                       
        
                                <div class="col-md-3"> <label class="pull-left"> Convulsions </label><b class="pull-left ">: </b></div>
                            <div class="col-md-3"> <asp:RadioButtonList ID="rdbConvulsions" runat="server" RepeatDirection="Horizontal">
                              <asp:ListItem Value="Yes" Selected="True">Yes</asp:ListItem>
                              <asp:ListItem Value="No">No</asp:ListItem>
                          </asp:RadioButtonList>
                                </div> 
                                 <div class="col-md-3"> <label class="pull-left"> TB </label><b class="pull-left ">: </b></div>
                             <div class="col-md-3"><asp:RadioButtonList ID="rdbTB" runat="server" RepeatDirection="Horizontal">
                              <asp:ListItem Value="Yes" Selected="True">Yes</asp:ListItem>
                              <asp:ListItem Value="No">No</asp:ListItem>
                          </asp:RadioButtonList>
                                 </div>
                                <div class="col-md-3"> <label class="pull-left"> Infertility </label><b class="pull-left ">: </b></div>
                             <div class="col-md-3"><asp:RadioButtonList ID="rdbInfertility" runat="server" RepeatDirection="Horizontal">
                              <asp:ListItem Value="Yes" Selected="True">Yes</asp:ListItem>
                              <asp:ListItem Value="No">No</asp:ListItem>
                          </asp:RadioButtonList>
                                 </div>
                                 <div class="col-md-3"> <label class="pull-left"> Other </label><b class="pull-left ">: </b></div>
                             <div class="col-md-3"><asp:RadioButtonList ID="rdbOther" runat="server" RepeatDirection="Horizontal">
                              <asp:ListItem Value="Yes" Selected="True">Yes</asp:ListItem>
                              <asp:ListItem Value="No">No</asp:ListItem>
                          </asp:RadioButtonList>
                                 </div>
                          </div> 
       </div>
                    </div>
                <div class="POuter_Box_Inventory" style="text-align: left;">
                    <div class="Purchaseheader">
                General Examination</div>
                    </div>
            
                <div class="POuter_Box_Inventory" style="text-align: left;">
                   <div class="row">
                            <div class="col-md-24">              
                             <div class="col-md-3"><label class="pull-left">Chief complaint </label><b class="pull-left "> : </b></div>
                             <div class="col-md-5">
                                 
                                <asp:TextBox ID="txtChiefcomplaint" runat="server"  ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender28" runat="server" TargetControlID="txtChiefcomplaint" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                             <div class="col-md-3"> <label class="pull-left"> history and physical exam </label><b class="pull-left ">: </b></div>
                             <div class="col-md-5">
                                 
                                <asp:TextBox ID="txthistoryandphysicalexam" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender29" runat="server" TargetControlID="txthistoryandphysicalexam" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div></div>
                       </div>
                    </div>

                   <div class="POuter_Box_Inventory" style="text-align: left;">
                       <div class="Purchaseheader">
                Abdominal Examination</div>
                    </div>   
                <div class="POuter_Box_Inventory" style="text-align: left;">
                   <div class="row">       
              <div class="col-md-24">              
                             <div class="col-md-3"><label class="pull-left">Date of Examination </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtAbdominalDateofExamination" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                   <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtAbdominalDateofExamination"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>

                             </div>
                                 
                             <div class="col-md-3"><label class="pull-left">Time </label><b class="pull-left "> : </b></div>
                             <div class="col-md-4">
                                 
                                
                            <uc2:StartTime ID="AbdominalTimeofExamination" runat="server" />
                             </div>
                  
                             <div class="col-md-2"><label class="pull-left">Staff  Performing </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtStaffPerforming" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender32" runat="server" TargetControlID="txtStaffPerforming" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                             <div class="col-md-3"><label class="pull-left">Abdominal scar </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">  
                                 <asp:RadioButtonList ID="rdbAbdominalscar" runat="server" RepeatDirection="Horizontal">
                              <asp:ListItem Value="Yes" Selected="True">Yes</asp:ListItem>
                              <asp:ListItem Value="No">No</asp:ListItem>
                          </asp:RadioButtonList>

                             </div>
                  
                             <div class="col-md-3"><label class="pull-left">If Yes why </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtAbdominalscarWhy" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender33" runat="server" TargetControlID="txtAbdominalscarWhy" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                             
                             </div>

                   </div>
                       <div class="row">  
                       <div class="col-md-24">              
                             <div class="col-md-3"><label class="pull-left">FHT per minute </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtFHTperminute" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender34" runat="server" TargetControlID="txtFHTperminute" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                           
                             <div class="col-md-3"><label class="pull-left">Contractions:strength </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtContractionsstrength" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender35" runat="server" TargetControlID="txtContractionsstrength" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
              
                             <div class="col-md-3"><label class="pull-left">Frequency </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtFrequency" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender36" runat="server" TargetControlID="txtFrequency" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                       
                             <div class="col-md-3"><label class="pull-left">Per 10 min duration secs </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtduration" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender37" runat="server" TargetControlID="txtduration" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                           
                           
                             </div>

                   </div>
                       <div class="row">  
                       <div class="col-md-24">
                             <div class="col-md-3"><label class="pull-left">fundal Height </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtfundalHeight" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender38" runat="server" TargetControlID="txtfundalHeight" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                           
                             <div class="col-md-3"><label class="pull-left">Lie </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtLie" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender39" runat="server" TargetControlID="txtLie" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                           
                             <div class="col-md-3"><label class="pull-left">Presentation </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtAbdominalPresentation" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender40" runat="server" TargetControlID="txtAbdominalPresentation" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                           
                             <div class="col-md-3"><label class="pull-left">Position </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtPosition" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender41" runat="server" TargetControlID="txtPosition" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                           
                             <div class="col-md-3"><label class="pull-left">Descent </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtDescent" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender42" runat="server" TargetControlID="txtDescent" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                           
                             <div class="col-md-3"><label class="pull-left">Engaged </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                   
                                 <asp:RadioButtonList ID="rdbEngaged" runat="server" RepeatDirection="Horizontal">
                              <asp:ListItem Value="Yes" Selected="True">Yes</asp:ListItem>
                              <asp:ListItem Value="No">No</asp:ListItem>
                          </asp:RadioButtonList>
                             </div>
                           </div>
                             </div>

                   </div>
                       
                       <div class="POuter_Box_Inventory" style="text-align: left;">
                          <div class="Purchaseheader">
                Vaginal Examination</div>
                </div><div class ="POuter_Box_Inventory" style="text-align: left;">
                     <div class="row">  
                       <div class="col-md-24">
                             <div class="col-md-3"><label class="pull-left">Date of Examination </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtVaginalDateOfExamination" runat="server"     ClientIDMode="Static" Style="z-index:1000;"
                                            ></asp:TextBox>
                                   <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtVaginalDateOfExamination"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                             </div>
                                 
                             <div class="col-md-3"><label class="pull-left">Time </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                 <uc2:StartTime ID="txtVaginalTimeOfExamination" runat="server" />
                             </div>
                  
                             <div class="col-md-3"><label class="pull-left">Staff  Performing </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtStaffPerformingVaginal" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender45" runat="server" TargetControlID="txtStaffPerformingVaginal" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                             
                           
                             <div class="col-md-3"><label class="pull-left">Reason for doing exam </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtReasonfordoingexam" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender46" runat="server" TargetControlID="txtReasonfordoingexam" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                             
                                                      </div>
                           </div>
                    <div class="row">  
                       <div class="col-md-24">
                            <div class="col-md-3"><label class="pull-left">external Genitalia  </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtexternalGenitalia" runat="server"   style="z-index:0;"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender47" runat="server" TargetControlID="txtexternalGenitalia" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                       
                             <div class="col-md-3"><label class="pull-left">Any Discharge </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                   
                                 <asp:RadioButtonList ID="rdbAnyDischarge" runat="server" RepeatDirection="Horizontal">
                              <asp:ListItem Value="Yes" Selected="True">Yes</asp:ListItem>
                              <asp:ListItem Value="No">No</asp:ListItem>
                          </asp:RadioButtonList>
                             </div>   
                                <div class="col-md-3"><label class="pull-left">Cervix Dilation (cm) </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtCervixDilation" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender48" runat="server" TargetControlID="txtCervixDilation" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                         
                                <div class="col-md-3"><label class="pull-left">Effacement (%)  </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtEffacement" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender49" runat="server" TargetControlID="txtEffacement" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                                   </div>
                           </div>
                    <div class="row">  
                       <div class="col-md-24">
                                <div class="col-md-3"><label class="pull-left">Applic to prespart   </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtApplictoprespart" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender50" runat="server" TargetControlID="txtApplictoprespart" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                       
                                                    <div class="col-md-3"><label class="pull-left">Membranes Intact </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                   
                                 <asp:RadioButtonList ID="rdbMembranesIntact" runat="server" RepeatDirection="Horizontal">
                              <asp:ListItem Value="Yes" Selected="True">Yes</asp:ListItem>
                              <asp:ListItem Value="No">No</asp:ListItem>
                          </asp:RadioButtonList>
                             </div>   
                                         <div class="col-md-3"><label class="pull-left">Cord Felt? </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                   
                                 <asp:RadioButtonList ID="rdbCordFelt" runat="server" RepeatDirection="Horizontal">
                              <asp:ListItem Value="Yes" Selected="True">Yes</asp:ListItem>
                              <asp:ListItem Value="No">No</asp:ListItem>
                          </asp:RadioButtonList>
                             </div>   
                                <div class="col-md-3"><label class="pull-left">Presentation   </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtPresentation" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender51" runat="server" TargetControlID="txtPresentation" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                                <div class="col-md-3"><label class="pull-left">Presenting Part   </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtPresentingPart" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender52" runat="server" TargetControlID="txtPresentingPart" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                         </div>
                           </div>
                    <div class="row">  
                       <div class="col-md-24">
                                <div class="col-md-3"><label class="pull-left">Station   </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtStation" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender53" runat="server" TargetControlID="txtStation" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                                <div class="col-md-3"><label class="pull-left">Moulding   </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtMoulding" runat="server"    ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender54" runat="server" TargetControlID="txtMoulding" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                                <div class="col-md-3"><label class="pull-left">Caput   </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtCaput" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender55" runat="server" TargetControlID="txtCaput" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                                <div class="col-md-3"><label class="pull-left">Pevlis:Public Arch   </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtPevlisPublicArch" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender56" runat="server" TargetControlID="txtPevlisPublicArch" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                                <div class="col-md-3"><label class="pull-left">Ischialspines   </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtIschialspines" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender57" runat="server" TargetControlID="txtIschialspines" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                       </div>
                           </div>
                    <div class="row">  
                       <div class="col-md-24">
                            <div class="col-md-3"><label class="pull-left">Sacral Promontory   </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                <asp:TextBox ID="txtSacralPromontory" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender58" runat="server" TargetControlID="txtSacralPromontory" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>

                             </div>
                                <div class="col-md-3"><label class="pull-left">Curve of Sacrum   </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                <asp:TextBox ID="txtCurveofSacrum" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender59" runat="server" TargetControlID="txtCurveofSacrum" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>

                             </div>
                                <div class="col-md-3"><label class="pull-left">Ischial Tuberosities   </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtIschialTuberosities" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender60" runat="server" TargetControlID="txtIschialTuberosities" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                               
                                         <div class="col-md-3"><label class="pull-left">Pelvis Adequate </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                   
                                 <asp:RadioButtonList ID="rdbPelvisAdequate" runat="server" RepeatDirection="Horizontal">
                              <asp:ListItem Value="Yes" Selected="True">Yes</asp:ListItem>
                              <asp:ListItem Value="No">No</asp:ListItem>
                          </asp:RadioButtonList>
                             </div> 
                            </div>
                           </div>
                    <div class="row">  
                       <div class="col-md-24">
                            <div class="col-md-3"><label class="pull-left">Attention: Critical Exam Features :   </label><b class="pull-left "></b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtAttentionCriticalExamFeatures" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender61" runat="server" TargetControlID="txtAttentionCriticalExamFeatures" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                                  <div class="col-md-3"><label class="pull-left">Attention: Labs: Blood Type    </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtAttentionLabsBloodType" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender62" runat="server" TargetControlID="txtAttentionLabsBloodType" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                              <div class="col-md-3"><label class="pull-left">Rh   </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtRh" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender63" runat="server" TargetControlID="txtRh" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                              <div class="col-md-3"><label class="pull-left">Hgb   </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtHgb" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender64" runat="server" TargetControlID="txtHgb" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                              
                            </div>
                           </div>
                    <div class="row">  
                       <div class="col-md-24">
                           <div class="col-md-3"><label class="pull-left">Date   </label><b class="pull-left "> : </b></div>

                             <div class="col-md-3">
                                <asp:TextBox ID="Date1" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                  <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="Date1"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
 
                             </div>
                                  <div class="col-md-3"><label class="pull-left">ISS    </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtISS" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender66" runat="server" TargetControlID="txtISS" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                            <div class="col-md-3"><label class="pull-left">Date   </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="Date2" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="Date2"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
 
                             </div>
                           <div class="col-md-3"><label class="pull-left">VDRL   </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="txtVDRL" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender68" runat="server" TargetControlID="txtVDRL" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                           <div class="col-md-3"><label class="pull-left">Date   </label><b class="pull-left "> : </b></div>
                             <div class="col-md-3">
                                 
                                <asp:TextBox ID="Date3" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="Date3"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
 
                             </div>
                           
                            </div>
                           </div>
                    <div class="row" style="display:none">  
                       <div class="col-md-24">
                           <div class="col-md-6"><label class="pull-left">Name/Date/TimeStamp For Last Person Editing   </label><b class="pull-left "> : </b></div>
                             <div class="col-md-4">
                                 
                                <asp:TextBox ID="txtNameDateStamp" runat="server"     ClientIDMode="Static"
                                            ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender70" runat="server" TargetControlID="txtNameDateStamp" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                             </div>
                                
                    </div>
                           
      </div>
        </div>
                        <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:Label ID="lblPID" runat="server"  Visible="false"></asp:Label>
                <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton" ClientIDMode="Static" OnClientClick="return chkVital(this)" TabIndex="69" OnClick="btnSave_Click" />
                <asp:Button ID="btnUpdate" runat="server" Text="Update" Visible="false" ClientIDMode="Static" CssClass="ItDoseButton" TabIndex="69" OnClientClick="return chkVital(this)" OnClick="btnUpdate_Click" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="ItDoseButton" TabIndex="69" OnClick="btnCancel_Click" />
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:GridView ID="grdPhysical" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowCommand="grdPhysical_RowCommand" OnRowDataBound="grdPhysical_RowDataBound" TabIndex="6">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                        </asp:TemplateField>
                        <%-- <asp:TemplateField HeaderText="Patient Name">
                            <ItemTemplate>
                                <asp:Label ID="lblGrav" runat="server" Text='<%#Eval("Grav") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                        </asp:TemplateField>--%>
                        <asp:TemplateField HeaderText="Grav">
                            <ItemTemplate>
                                <asp:Label ID="lblGrav" runat="server" Text='<%#Eval("Grav", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="P">
                            <ItemTemplate>
                                <asp:Label ID="lblP" runat="server" Text='<%#Eval("P", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="+">
                            <ItemTemplate>
                                <asp:Label ID="lblPlus" runat="server" Text='<%#Eval("Plus", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Living">
                            <ItemTemplate>
                                <asp:Label ID="lblLiving" runat="server" Text='<%#Eval("Living", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Rhythm">
                            <ItemTemplate>
                                <asp:Label ID="lblDead" runat="server" Text='<%#Eval("Dead", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="LMP">
                            <ItemTemplate>
                                <asp:Label ID="lblLMP" runat="server" Text='<%#Eval("LMP", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="EDD" Visible="true">
                            <ItemTemplate>
                                <asp:Label ID="lblEDD" runat="server" Text='<%#Eval("EDD", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Gestation">
                            <ItemTemplate>
                                <asp:Label ID="lblGestation" runat="server" Text='<%#Eval("Gestation", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Wks">
                            <ItemTemplate>
                                <asp:Label ID="lblWks" runat="server" Text='<%#Eval("Wks", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Days">
                            <ItemTemplate>
                                <asp:Label ID="lblDays" runat="server" Text='<%#Eval("Days", "{0:f2}")  %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Anenatalcare">
                            <ItemTemplate>
                                <asp:Label ID="lblAnenatalcare" runat="server" Text='<%# Eval("Anenatalcare", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Visit Where" >
                            <ItemTemplate>
                                <asp:Label ID="lblVisitWhere" runat="server" Text='<%#Eval("VisitWhere", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Hospital Deliveries" >
                            <ItemTemplate>
                                <asp:Label ID="lblHospitalDeliveries" runat="server" Text='<%#Eval("HospitalDeliveries", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Entry By">
                            <ItemTemplate>
                                <asp:Label ID="lblEntry" runat="server" Text='<%#Eval("EntryBy1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Entry Date">
                            <ItemTemplate>
                                <asp:Label ID="lblDate" runat="server" Text='<%#Util.GetDateTime(Eval("Date4")).ToString("dd-MMM-yyyy") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Entry Time">
                            <ItemTemplate>
                                <asp:Label ID="lblTime" runat="server" Text='<%#Util.GetDateTime(Eval("Time1")).ToString("hh:mm tt") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Edit">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CausesValidation="false" CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/edit.png" runat="server" />
                                <asp:Label ID="lblUserID" Text='<%#Eval("EntryBy") %>' runat="server" Visible="false"></asp:Label>
                                <asp:Label ID="lblID" Text='<%#Eval("Id") %>' runat="server" Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        
                       </div>
    </form>
</body>
</html>
