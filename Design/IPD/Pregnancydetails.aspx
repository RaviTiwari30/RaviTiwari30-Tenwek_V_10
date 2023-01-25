<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Pregnancydetails.aspx.cs" Inherits="Design_IPD_Pregnancydetails" %>

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
          </script>
    <form id="form1" runat="server">
        
        <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>PREGNANCY DETAILS</b>
                <br />                
            </div>
        
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                    PREGNANCIES
                </div>
            </div>
        
            <div class="POuter_Box_Inventory">
                <div class="row">
                    
                    <div class="col-md-4">
                        <label class="pull-left">Pregnancy nr.</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <asp:TextBox ID="txtPregnancyNr" runat="server" ClientIDMode="Static"
                            onkeypress="return checkForSecond(this,event)" TabIndex="1" MaxLength="100" ToolTip="Pregnancy nr."></asp:TextBox>
                    </div>
                    <div class="col-md-4">
                        <label class="pull-left">Date / Time</label>
                        <b class="pull-right">:</b>
                    </div> 
                    <div class="col-md-3">
                        <asp:TextBox ID="txtDate" runat="server"
                            ToolTip="Click To Select Date" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="caldate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy" ClearTime="true"> </cc1:CalendarExtender>
                    </div>
                    <div class="col-md-2">
                        <asp:TextBox ID="txtTime" TabIndex="6" runat="server"  Width="80px" ></asp:TextBox>
                        <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time" TargetControlID="txtTime" AcceptAMPM="True"></cc1:MaskedEditExtender>
                        <cc1:MaskedEditValidator ID="maskTimeStart" runat="server" ControlToValidate="txtTime" ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Please Enter Time" InvalidValueMessage="Invalid Time ON" ForeColor="Red" Display="None"></cc1:MaskedEditValidator>


                        <%--<uc2:StartTime ID="StartTime" runat="server" />--%>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Gravida</label>
                        <b class="pull-right">: </b>
                    </div>
                    <div class="col-md-4">
                        <asp:TextBox ID="txtGravida" runat="server" ClientIDMode="Static" TabIndex="3" MaxLength="100" ToolTip="Enter gravida" AutoCompleteType="None"></asp:TextBox>
                    </div>             
                </div>
                <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Births</label>
                                <b class="pull-right">: </b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtBirths" runat="server"  ClientIDMode="Static" TabIndex="4" MaxLength="1" ToolTip="Enter Birhts"  AutoCompleteType="None"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Pre. Gestational Age</label>
                                <b class="pull-right">:</b>
                             </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtPregnancyGestationalAge" runat="server"  ClientIDMode="Static" TabIndex="5" maxLength="10" ToolTip="Enter Pregnancy Gestational Age" AutoCompleteType="None"></asp:TextBox>                                
                            
                              <%--  <cc1:FilteredTextBoxExtender ID="fttxtP" runat="server" TargetControlID="txtPregnancyGestationalAge" ValidChars="0987654321">
                                </cc1:FilteredTextBoxExtender>--%>
                             </div>
                            <div class="col-md-4">
                                <label class="pull-left">Nr. of fetuses</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtNroffetus" runat="server"  ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                            </div>    
                            </div>
                <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left">Delivery Mode</label>
                        <b class="pull-right">: </b>
                    </div>
                    <div class="col-md-4">
                        <asp:DropDownList ID="rdbdelivery" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Value="Normal" Selected="True">Normal</asp:ListItem>
                            <asp:ListItem Value="Breech">Breech</asp:ListItem>
                            <asp:ListItem Value="Caesarean">Caesarean</asp:ListItem>
                            <asp:ListItem Value="Forceps">Forceps</asp:ListItem>
                            <asp:ListItem Value="Vacuum">Vacuum</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-4">
                        <label class="pull-left">Booked</label>
                        <b class="pull-right">: </b>
                    </div>
                    <div class="col-md-4">
                        <asp:RadioButtonList ID="rdbbooked" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Value="Yes" Selected="True">Yes</asp:ListItem>
                            <asp:ListItem Value="No">No</asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                    <div class="col-md-4">
                        <label class="pull-left">VDRL</label>
                        <b class="pull-right">: </b>
                    </div>
                    <div class="col-md-4">
                        <asp:TextBox ID="txtVDRL" runat="server" ClientIDMode="Static" TabIndex="7" MaxLength="100" ToolTip="Enter VDRL" AutoCompleteType="None"></asp:TextBox>
                    </div>
                </div>                                 
                <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Rh</label>
                            <b class="pull-right">: </b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtRH" runat="server" ClientIDMode="Static" TabIndex="8" MaxLength="100" ToolTip="Enter Rh" AutoCompleteType="None"></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">High Systolic Value</label>
                            <b class="pull-right">: </b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtHighSystolicValue" runat="server" CssClass="requiredField" ClientIDMode="Static" TabIndex="9" MaxLength="100" ToolTip="High Systolic Value"></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                High Diastolic value
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtHighDiastolicvalue" runat="server" ClientIDMode="Static"
                                TabIndex="10" MaxLength="100" ToolTip="High Diastolic value"></asp:TextBox>
                        </div>    
        </div>   
                <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left">Proteinuria</label>
                        <b class="pull-right">: </b>
                    </div>
                    <div class="col-md-4">
                        <asp:RadioButtonList ID="rdbProteinuria" runat="server" RepeatDirection="Horizontal" Style="margin-left: 0px">
                            <asp:ListItem Value="Yes" Selected="True">Yes</asp:ListItem>
                            <asp:ListItem Value="No">No</asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                    <div class="col-md-4">
                        <label class="pull-left">
                            Labour Duration
                        </label>
                        <b class="pull-right">: </b>
                    </div>
                    <div class="col-md-4">
                        <asp:TextBox ID="txtLabourDuration" runat="server" ClientIDMode="Static"
                            TabIndex="11" MaxLength="100" ToolTip="Labour Duration"></asp:TextBox>
                    </div>

                </div>
                <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left">Induction Method</label>
                        <b class="pull-right">:</b></div>
                    <div class="col-md-12">
                        <asp:RadioButtonList ID="rdbColumnX" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Value="Not Needed">Not Induced</asp:ListItem>
                            <asp:ListItem Value="Unkown">Unkown</asp:ListItem>
                            <asp:ListItem Value="Prostaglandin">Prostaglandin</asp:ListItem>
                            <asp:ListItem Value="Oxytocin">Oxytocin</asp:ListItem>
                            <asp:ListItem Value="Incubation Method" Selected="True">AROM</asp:ListItem>
                        </asp:RadioButtonList>

                    </div>
                    <div class="col-md-4">
                        <asp:TextBox ID="txtAROM" runat="server" ClientIDMode="Static" TabIndex="12" MaxLength="100" ToolTip="Enter AROM" AutoCompleteType="None"></asp:TextBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left">
                            Induction Indication
                        </label>
                        <b class="pull-right">: </b>
                    </div>
                    <div class="col-md-4">
                        <asp:TextBox ID="txtInductionIndication" runat="server" ClientIDMode="Static"
                            TabIndex="13" MaxLength="100"
                            ToolTip="Enter Induction Indication" AutoCompleteType="None"></asp:TextBox>
                    </div>
                    <div class="col-md-4">
                        <label class="pull-left">
                            Anaesthesia
                        </label>
                        <b class="pull-right">: </b>
                    </div>
                    <div class="col-md-12">
                        <asp:RadioButtonList ID="rdbAnaesthesia" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Value="None" >None</asp:ListItem>
                            <asp:ListItem Value="General Anaesthesia" Selected="True">General Anaesthesia</asp:ListItem>
                            <asp:ListItem Value="Spnial Anaesthesia">Spnial Anaesthesia</asp:ListItem>
                            <asp:ListItem Value="Local Anaesthesia">Local Anaesthesia</asp:ListItem>
                            <asp:ListItem Value="Anaesthesia"> G.E.T.A </asp:ListItem>
                        </asp:RadioButtonList>
                    </div>

                </div>
                <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left">
                            Complications
                        </label>
                        <b class="pull-right">: </b>
                    </div>
                    <div class="col-md-4">
                        <asp:TextBox ID="txtGETAComplications" runat="server" CssClass="requiredField" ClientIDMode="Static"
                            TabIndex="14" MaxLength="100" ToolTip="G.E.T.A Complications"></asp:TextBox>
                    </div>
                    <div class="col-md-4">
                        <label class="pull-left">
                            Perineum
                        </label>
                        <b class="pull-right">: </b>
                    </div>
                    <div class="col-md-12">
                        <asp:RadioButtonList ID="rdbTear" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Value="Intact">Intact</asp:ListItem>
                            <asp:ListItem Value="1 tear">1 tear</asp:ListItem>
                            <asp:ListItem Value="2 tear">2 tear</asp:ListItem>
                            <asp:ListItem Value="3 tear">3 tear</asp:ListItem>
                            <asp:ListItem Value="4 tear">4 tear</asp:ListItem>
                            <asp:ListItem Value="Perineum">Episiotomy</asp:ListItem>
                        </asp:RadioButtonList>
                    </div>

                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="col-md-4">
                            <label class="pull-left">
                                Blood Loss
                            </label>
                            <b class="pull-right">: </b>
                        </div>
                        <div class="col-md-2">
                            <asp:TextBox ID="txtEpisiotomyBloodLoss" runat="server" CssClass="requiredField" ClientIDMode="Static"
                                TabIndex="15" MaxLength="100" ToolTip="Episiotomy Blood Loss"></asp:TextBox>
                        </div>
                        <div class="col-md-2">
                            <asp:DropDownList ID="ddlBloodlossunit" runat="server">
                                <asp:ListItem Value="ml" Selected="True">ml</asp:ListItem>
                                <asp:ListItem Value="lt">ltr</asp:ListItem>
                                <asp:ListItem Value="dl">dl</asp:ListItem>
                                <asp:ListItem Value="cl">cl</asp:ListItem>
                                <asp:ListItem Value="ul">ul</asp:ListItem>
                                <asp:ListItem Value="Estimated">Estimated</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Retained Placenta
                            </label>
                            <b class="pull-right">: </b>
                        </div>
                        <div class="col-md-4">
                            <asp:RadioButtonList ID="rdbRetainedPlacenta" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="Yes" Selected="True">Yes</asp:ListItem>
                                <asp:ListItem Value="No">No</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Post Labour Condition
                            </label>
                            <b class="pull-right">: </b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtPostLabourCondition" runat="server" CssClass="requiredField" ClientIDMode="Static"
                                TabIndex="15" MaxLength="100" ToolTip="Post Labour Condition"></asp:TextBox>
                        </div>


                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left">Outcome</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-20">
                          <asp:RadioButtonList ID="rdbOutcome" runat="server" RepeatDirection="Horizontal" style="margin-left: 0px">
                              <asp:ListItem Value="Alive" Selected="True">Alive</asp:ListItem>
                              <asp:ListItem Value="Still Born">Still Born</asp:ListItem>
                              <asp:ListItem Value="Early Neonatal Death">Early Neonatal Death</asp:ListItem>
                              <asp:ListItem Value="Late Neonatal Death">Late Neonatal Death</asp:ListItem>
                              <asp:ListItem Value="Death Uncertain">Death Uncertain</asp:ListItem>                                                                                   
                          </asp:RadioButtonList>
                        </div>
                </div>
                    <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Documented By
                                </label>  
                                <b class="pull-right">:</b>                              
                        </div>

                        <div class="col-md-4">
                            <asp:Label ID="lblEmployeeName" runat="server"></asp:Label>
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
                         <asp:Label ID="lblID" runat="server"  Visible="false"></asp:Label>
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
        
        <div class="POuter_Box_Inventory" style="display:none">
            <div class="row">
            <div class="col-md-24">
                <div style="overflow:auto;">
                       <asp:GridView ID="grdPregnancyDetails" runat="server" AutoGenerateColumns="False"   CssClass="GridViewStyle" >

                                    <Columns>
                                        <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-CssClass="GridViewHeaderStyle">
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex+1 %>
                                            </ItemTemplate>

                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px"></HeaderStyle>

                                            <ItemStyle CssClass="GridViewItemStyle" Width="20px"></ItemStyle>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="PregnancyNr">
                                            <ItemTemplate>
                                                <asp:Label ID="lblPregnancyNr" runat="server" Text='<%#Eval("PregnancyNr") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Gravida">
                                            <ItemTemplate>
                                                <asp:Label ID="lblGravida" runat="server" Text='<%#Eval("Gravida") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Births">
                                            <ItemTemplate>
                                                <asp:Label ID="lblBirths" runat="server" Text='<%#Eval("Births") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="226px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" VerticalAlign="Middle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="PregnancyGestationalAge">
                                            <ItemTemplate>
                                                <asp:Label ID="lblPregnancyGestationalAge" runat="server" Text='<%#Eval("PregnancyGestationalAge") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Nroffetuses">
                                            <ItemTemplate>
                                                <asp:Label ID="lblNroffetuses" runat="server" Text='<%#Eval("Nroffetuses") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="226px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="DeliveryMode">
                                            <ItemTemplate>
                                                <asp:Label ID="lblDeliveryMode" runat="server" Text='<%#Eval("DeliveryMode") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        
                                        <asp:TemplateField HeaderText="Booked">
                                            <ItemTemplate>
                                                <asp:Label ID="lblBooked" runat="server" Text='<%#Eval("Booked") %>'></asp:Label>
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