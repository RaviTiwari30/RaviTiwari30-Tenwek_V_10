<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Admissionsickpatient.aspx.cs" Inherits="Design_IPD_Admissionsickpatient" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/Time.ascx" TagName="StartTime" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <style type="text/css">
        .auto-style1 {
            width: 183px;
        }
    </style>
</head>
<body>
    
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
   <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>   
    <script type="text/javascript" src="../../Scripts/shortcut.js"></script>
    <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css" />
     <script type="text/javascript">
         function checkDate(sender, args) {
             var dt = new Date();
             if (sender._selectedDate > dt) {
                 sender._textbox
                .set_Value(dt.format(sender._format));
             }
         }
         
     </script>
    <form id="Form1" runat="server">
       
        <div id="Pbody_box_inventory">
         <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Admission of Sick Patient</b>
                <br />
             </div>   
           
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                    Consultation Note
                </div>
                </div>
            
            <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24">
                     <div class="col-md-3">
                                <label class="pull-left">Service</label>
                                <b class="pull-right">:</b>
                     </div>
                         <div class="col-md-5">
                                <asp:TextBox ID="txtService" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Service" MaxLength="100" ></asp:TextBox>
                        </div>
                    <div class="col-md-2">
                         <label class="pull-left">Date/Time</label>
                         <b class="pull-right">:</b>
                        </div>
                        
                    <div class="col-md-3">
                                <asp:TextBox ID="txtDate" runat="server"  CssClass="disable_future_dates" 
                                ToolTip="Click To Select Date" Width="100px" TabIndex="1"  
                                ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="caldate" runat="server" TargetControlID="txtDate"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        
                            
                     </div>
                         <div class="col-md-3">
                                <%-- <asp:TextBox ID="txtTime" TabIndex="6" runat="server" Width="100px" placeholder="hh:mm(AM|PM)"></asp:TextBox>
                            <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time" TargetControlID="txtTime" AcceptAMPM="True"></cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator ID="maskTimeStart" runat="server" ControlToValidate="txtTime" ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Please Enter Time" InvalidValueMessage="Invalid Time ON" ForeColor="Red" Display="None"></cc1:MaskedEditValidator>
                        --%>
                             
                            <uc2:StartTime ID="StartTime" runat="server" />
                         </div>
                 
                     <div class="col-md-3">
                         <label class="pull-left">History</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtHistory" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="History" MaxLength="100" ></asp:TextBox>
                     </div>
               </div> 
          </div>
          <div class="row">
                <div class="col-md-24">
                     <div class="col-md-3">
                         <label class="pull-left">Cheif Complaints</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtChiefComplaints" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Cheif Complaints" MaxLength="100" ></asp:TextBox>
                     </div>
               
                     <div class="col-md-3">
                         <label class="pull-left">Allergies</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtAllergies" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Allergies" MaxLength="100" ></asp:TextBox>
                     </div>
                     <div class="col-md-3">
                         <label class="pull-left">Meds</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtMeds" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Meds" MaxLength="100" ></asp:TextBox>
                     </div>
               </div> 
          </div>
          <div class="row">
                <div class="col-md-24">
                     <div class="col-md-3">
                         <label class="pull-left">PMH</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtPMH" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="PMH" MaxLength="100" ></asp:TextBox>
                     </div>
                     <div class="col-md-3">
                         <label class="pull-left">PSH</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtPSH" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="PSH" MaxLength="100" ></asp:TextBox>
                     </div>
                     <div class="col-md-3">
                         <label class="pull-left">Social Hx</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtSocialHX" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Social Hx"  MaxLength="100" ></asp:TextBox>
                     </div>
               </div> 
          </div>             
          <div class="row">
                <div class="col-md-24">
                     <div class="col-md-3">
                         <label class="pull-left">Family Hx</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtFamilyHX" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Family Hx" MaxLength="100" ></asp:TextBox>
                     </div>
                     <div class="col-md-3">
                         <label class="pull-left">Physical Exam</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtPhysicalExam" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Physical Exam" MaxLength="100" ></asp:TextBox>
                     </div>
                     <div class="col-md-3">
                         <label class="pull-left">Vital Signs</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtVitalSigns" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Vital Signs" MaxLength="100" ></asp:TextBox>
                     </div>
               </div> 
          </div> 
          <div class="row">
                <div class="col-md-24">
                     <div class="col-md-3">
                         <label class="pull-left">General</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtGeneral" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="General" MaxLength="100" ></asp:TextBox>
                     </div>
                     <div class="col-md-3">
                         <label class="pull-left">HEENT</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtHEENT" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="HEENT" MaxLength="100" ></asp:TextBox>
                     </div>
                     <div class="col-md-3">
                         <label class="pull-left">Neck</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtNeck" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Neck" MaxLength="100" ></asp:TextBox>
                     </div>
               </div> 
          </div>
          <div class="row">
                <div class="col-md-24">
                     <div class="col-md-3">
                         <label class="pull-left">Chest/ Respiratory</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtChestRespiratory" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Chest/ Respiratory" MaxLength="100" ></asp:TextBox>
                     </div>
                     <div class="col-md-3">
                         <label class="pull-left">Cardiovascular</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtCardiovascular" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Cardiovascular" MaxLength="100" ></asp:TextBox>
                     </div>
                     <div class="col-md-3">
                         <label class="pull-left">Abdomen</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtAbdomen" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Abdomen" MaxLength="100" ></asp:TextBox>
                     </div>
               </div> 
          </div>
          <div class="row">
                <div class="col-md-24">
                     <div class="col-md-3">
                         <label class="pull-left">GU/Rectal/Pelvic</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtGURectalPelvic" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="GU/Rectal/Pelvic" MaxLength="100" ></asp:TextBox>
                     </div>
                     <div class="col-md-3">
                         <label class="pull-left">Black/joints</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtBlackJoints" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Black/joints" MaxLength="100" ></asp:TextBox>
                     </div>
                     <div class="col-md-3">
                         <label class="pull-left">Extermities</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtExtermities" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Extermities" MaxLength="100" ></asp:TextBox>
                     </div>
               </div> 
          </div> 
           <div class="row">
                <div class="col-md-24">
                     <div class="col-md-3">
                         <label class="pull-left">CNS</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtCNS" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="CNS" MaxLength="100" ></asp:TextBox>
                     </div>
                     <div class="col-md-3">
                         <label class="pull-left">Skin</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtSkin" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Skin" MaxLength="100" ></asp:TextBox>
                     </div>
                     <div class="col-md-3">
                         <label class="pull-left">Diagnostic Result</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtDiagnosticResult" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Diagnostic Result" MaxLength="100" ></asp:TextBox>
                     </div>
               </div> 
          </div> 
          <div class="row">
                <div class="col-md-24">
                     <div class="col-md-3">
                         <label class="pull-left">Laboratory</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtLaboratory" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Laboratory" MaxLength="100" ></asp:TextBox>
                     </div>
                     <div class="col-md-3">
                         <label class="pull-left">Imaging</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtImaging" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Imaging" MaxLength="100" ></asp:TextBox>
                     </div>
                     <div class="col-md-3">
                         <label class="pull-left">Assessment/ Plan</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtAssessmentPlan" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Assessment/ Plan" MaxLength="100" ></asp:TextBox>
                     </div>
               </div> 
          </div> 
          <div class="row">
                <div class="col-md-24">
                     <div class="col-md-3">
                         <label class="pull-left">Impression</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtImpression" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Impression" MaxLength="100" ></asp:TextBox>
                     </div>
                     <div class="col-md-3">
                         <label class="pull-left">Recommendations</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtRecommendations" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Recommendations" MaxLength="100" ></asp:TextBox>
                     </div>
                     <div class="col-md-3">
                         <label class="pull-left">Student's Name</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtStudentName" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Student's Name" MaxLength="100" ></asp:TextBox>
                     </div>
               </div> 
          </div> 
          <div class="row">
                <div class="col-md-24">
                     <div class="col-md-3">
                         <label class="pull-left">Doctor's Name</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtDoctorName" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Doctor's Name" MaxLength="100" ></asp:TextBox>
                     </div>
                     <div class="col-md-3">
                         <label class="pull-left">Supervising Consultant</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtSupervisingConsultant" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Supervising Consultant" MaxLength="100" ></asp:TextBox>
                     </div>
               </div> 
          </div> 
        
                </div>
            <div class="POuter_Box_Inventory">
          <div class="row">
                <div class="col-md-24">
                     <div class="col-md-8">
                         </div>
                     <div class="col-md-8">
                         <asp:Label ID="lblPID" runat="server"  Visible="false"></asp:Label>
                        <%-- <asp:Button ID="btnSubmit" runat="server"  CssClass="ItDoseButton" Text="Save" ToolTip="Click To Save"  OnClick="btnSubmit_Click"  />--%>
              <asp:Button ID="btnUpdate" runat="server" ClientIDMode="Static" CssClass="ItDoseButton" Text="Update" ToolTip="Click To Update"   CausesValidation="false"  Visible="false" OnClick="btnUpdate_Click" />
                <asp:Button ID="btnCancel" TabIndex="7" runat="server" Text="Cancel" CssClass="ItDoseButton" Visible="false"  OnClick="btnCancel_Click"    CausesValidation="false"  />
             
                         <asp:Button ID="btnSave" type="submit" runat="server" Text="Save" OnClick="btnSubmit_Click" CausesValidation="false"  />

                     </div>
                     <div class="col-md-8">
                         </div>
                    </div>
              </div>
                </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
            <div class="col-md-24">
                <div style="overflow:auto;">
                       <asp:GridView ID="grdSickPatientsDetails" runat="server" AutoGenerateColumns="False"   CssClass="GridViewStyle" OnRowDataBound="grdSickPatientsDetails_RowDataBound" OnRowCommand="grdSickPatientsDetails_RowCommand">

                                    <Columns>
                                        <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-CssClass="GridViewHeaderStyle">
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex+1 %>
                                            </ItemTemplate>

                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px"></HeaderStyle>

                                            <ItemStyle CssClass="GridViewItemStyle" Width="20px"></ItemStyle>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="History">
                                            <ItemTemplate>
                                                <asp:Label ID="lblHistory" runat="server" Text='<%#Eval("History") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Service">
                                            <ItemTemplate>
                                                <asp:Label ID="lblService" runat="server" Text='<%#Eval("Service") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="ChiefComplaints">
                                            <ItemTemplate>
                                                <asp:Label ID="lblChiefComplaints" runat="server" Text='<%#Eval("ChiefComplaints") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="226px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" VerticalAlign="Middle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Allergies">
                                            <ItemTemplate>
                                                <asp:Label ID="lblAllergies" runat="server" Text='<%#Eval("Allergies") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Meds">
                                            <ItemTemplate>
                                                <asp:Label ID="lblMeds" runat="server" Text='<%#Eval("Meds") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="226px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="PMH">
                                            <ItemTemplate>
                                                <asp:Label ID="lblPMH" runat="server" Text='<%#Eval("PMH") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        
                                        <asp:TemplateField HeaderText="PSH">
                                            <ItemTemplate>
                                                <asp:Label ID="lblPSH" runat="server" Text='<%#Eval("PSH") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
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
                                                <asp:Label ID="lblDate" runat="server" Text='<%#Util.GetDateTime(Eval("Date")).ToString("dd-MMM-yyyy") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150" />
                                        </asp:TemplateField>
                        
                                        <asp:TemplateField HeaderText="Entry Time">
                                            <ItemTemplate>
                                                <asp:Label ID="lblTime" runat="server" Text='<%#Util.GetDateTime(Eval("Time")).ToString("hh:mm tt") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150" />
                                        </asp:TemplateField>
                        
                                        <asp:TemplateField HeaderText="Edit" >
                                            <ItemTemplate  >
                                                <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CausesValidation="false"   CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/edit.png" runat="server" />
                                              
                                                <asp:Label ID="lblID" Text='<%#Eval("Id") %>' runat="server" Visible="FALSE"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>

                                    </Columns>
                                    <PagerSettings FirstPageText="First" LastPageText="Last" Mode="NumericFirstLast" PageButtonCount="5" />
                                </asp:GridView>
                  <div id="divdata"></div>


                    </div>
            </div>
            </div>
        </div>
            </div>
           
</form>
</body>
</html>

