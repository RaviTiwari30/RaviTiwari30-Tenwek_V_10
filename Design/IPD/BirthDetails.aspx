<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BirthDetails.aspx.cs" Inherits="Design_ip_BirthDetails" %>



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
                <b>Birth Details</b>
                <br />
             </div>   
           
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                    Birth Details
                </div>
                </div>
            
            <div class="POuter_Box_Inventory">
            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">Examination Date     </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-3">
                                    <asp:TextBox ID="txtDate" runat="server"></asp:TextBox>
                                       
                                      <cc1:CalendarExtender ID="caldate" PopupButtonID="ucFromDate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy"> </cc1:CalendarExtender> 
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">Examination Time </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    
                                    
                            <uc2:StartTime ID="StartTime" runat="server" />
                                </div>

                            </div>


                </div>
            
            <div class="POuter_Box_Inventory">
          <div class="row">
                <div class="col-md-24">
                     <div class="col-md-3">
                         <label class="pull-left">Mother's Encounter Nr.</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtMothersEncounterNr" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Mother's Encounter Nr." MaxLength="100" ></asp:TextBox>
                           <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtMothersEncounterNr" ValidChars="0987654321abcdefghijklmnopqrstuvwxyz">
                                </cc1:FilteredTextBoxExtender>
                     </div>
               
                     <div class="col-md-3">
                         <label class="pull-left">Delivery Nr.(para)</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtDeliveryNrpara" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Delivery Nr.(para)" MaxLength="100" ></asp:TextBox>
                           <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" TargetControlID="txtDeliveryNrpara" ValidChars="0987654321abcdefghijklmnopqrstuvwxyz">
                                </cc1:FilteredTextBoxExtender>
                     </div>
                     <div class="col-md-3">
                         <label class="pull-left">Delivery Place</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtDeliveryPlace" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Delivery Place" MaxLength="100" ></asp:TextBox>
                           <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" TargetControlID="txtDeliveryPlace" ValidChars="0987654321abcdefghijklmnopqrstuvwxyz">
                                </cc1:FilteredTextBoxExtender>
                     </div>
               </div> 
          </div>
          <div class="row">
                <div class="col-md-24">
                     <div class="col-md-3">
                         <label class="pull-left">Delivery Mode</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtDeliveryMode" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Delivery Mode" MaxLength="100" ></asp:TextBox>
                           <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender6" runat="server" TargetControlID="txtDeliveryMode" ValidChars="0987654321abcdefghijklmnopqrstuvwxyz">
                                </cc1:FilteredTextBoxExtender>
                     </div>
                     <div class="col-md-3">
                         <label class="pull-left">Face presentation</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtFacepresentation" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Face presentation" MaxLength="100" ></asp:TextBox>
                           <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender7" runat="server" TargetControlID="txtFacepresentation" ValidChars="0987654321abcdefghijklmnopqrstuvwxyz">
                                </cc1:FilteredTextBoxExtender>
                     </div>
                     <div class="col-md-3">
                         <label class="pull-left">Delivery rank</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtDeliveryrank" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Delivery rank"  MaxLength="100" ></asp:TextBox>
                           <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender8" runat="server" TargetControlID="txtDeliveryrank" ValidChars="0987654321abcdefghijklmnopqrstuvwxyz">
                                </cc1:FilteredTextBoxExtender>
                     </div>
               </div> 
          </div>             
          <div class="row">
                <div class="col-md-24">
                     <div class="col-md-3">
                         <label class="pull-left">Apgar score 1 min</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtApgarscore1min" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Apgar score 1 min" MaxLength="100" ></asp:TextBox>
                           <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender9" runat="server" TargetControlID="txtApgarscore1min" ValidChars="0987654321abcdefghijklmnopqrstuvwxyz">
                                </cc1:FilteredTextBoxExtender>
                     </div>
                    <div class="col-md-3">
                         <label class="pull-left">Apgar score 5 min</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtApgarscore5min" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Apgar score 5 min" MaxLength="100" ></asp:TextBox>
                           <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender10" runat="server" TargetControlID="txtApgarscore5min" ValidChars="0987654321abcdefghijklmnopqrstuvwxyz">
                                </cc1:FilteredTextBoxExtender>
                     </div> 
                        <div class="col-md-3">
                         <label class="pull-left">Apgar score 10 min</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtApgarscore10min" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Apgar score 10 min" MaxLength="100" ></asp:TextBox>
                           <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender11" runat="server" TargetControlID="txtApgarscore10min" ValidChars="0987654321abcdefghijklmnopqrstuvwxyz">
                                </cc1:FilteredTextBoxExtender>
                     </div>               </div> 
          </div> 
          <div class="row">
                <div class="col-md-24">
                     <div class="col-md-3">
                         <label class="pull-left">Condition</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtCondition" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Condition" MaxLength="100" ></asp:TextBox>
                           <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender12" runat="server" TargetControlID="txtCondition" ValidChars="0987654321abcdefghijklmnopqrstuvwxyz">
                                </cc1:FilteredTextBoxExtender>
                     </div>
                     <div class="col-md-3">
                         <label class="pull-left">Weight at birth</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtWeightatbirth" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Weight at birth" MaxLength="100" ></asp:TextBox>
                           <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender13" runat="server" TargetControlID="txtWeightatbirth" ValidChars="0987654321">
                                </cc1:FilteredTextBoxExtender>
                     </div>
                     <div class="col-md-3">
                         <label class="pull-left">Length at birth</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtLengthatbirth" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Length at birth" MaxLength="100" ></asp:TextBox>
                           <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender14" runat="server" TargetControlID="txtLengthatbirth" ValidChars="0987654321">
                                </cc1:FilteredTextBoxExtender>
                     </div>
               </div> 
          </div>
          <div class="row">
                <div class="col-md-24">
                     <div class="col-md-3">
                         <label class="pull-left">Head circumference</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtHeadcircumference" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Head circumference" MaxLength="100" ></asp:TextBox>
                           <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender15" runat="server" TargetControlID="txtHeadcircumference" ValidChars="0987654321abcdefghijklmnopqrstuvwxyz">
                                </cc1:FilteredTextBoxExtender>
                     </div>
                     <div class="col-md-3">
                         <label class="pull-left">Scored gestational age</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtScoredgestationalage" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Scored gestational age" MaxLength="100" ></asp:TextBox>
                           <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender16" runat="server" TargetControlID="txtScoredgestationalage" ValidChars="0987654321">
                                </cc1:FilteredTextBoxExtender>
                     </div>
                     <div class="col-md-3">
                         <label class="pull-left">Feeding</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtFeeding" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Feeding" MaxLength="100" ></asp:TextBox>
                           <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender18" runat="server" TargetControlID="txtFeeding" ValidChars="0987654321abcdefghijklmnopqrstuvwxyz">
                                </cc1:FilteredTextBoxExtender>
                     </div>
               </div> 
          </div>
          <div class="row">
                <div class="col-md-24">
                     <div class="col-md-3">
                         <label class="pull-left">Congenital abnormality</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                                <asp:TextBox ID="txtCongenitalabnormality" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Congenital abnormality" MaxLength="100" ></asp:TextBox>
                           <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender19" runat="server" TargetControlID="txtCongenitalabnormality" ValidChars="0987654321abcdefghijklmnopqrstuvwxyz">
                                </cc1:FilteredTextBoxExtender>
                     </div>
                     <div class="col-md-3">
                         <label class="pull-left">Outcome</label>
                         <b class="pull-right">:</b>
                     </div>
                    <div class="col-md-5">
                                <asp:TextBox ID="txtOutcome" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Outcome" MaxLength="100" ></asp:TextBox>
                          <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender20" runat="server" TargetControlID="txtOutcome" ValidChars="0987654321abcdefghijklmnopqrstuvwxyz">
                                </cc1:FilteredTextBoxExtender>
                     </div>
 
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
                                        <asp:TemplateField HeaderText="MothersEncounterNr">
                                            <ItemTemplate>
                                                <asp:Label ID="lblMothersEncounterNr" runat="server" Text='<%#Eval("MothersEncounterNr") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle"  Width="120px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="DeliveryNrpara">
                                            <ItemTemplate>
                                                <asp:Label ID="lblDeliveryNrpara" runat="server" Text='<%#Eval("DeliveryNrpara") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle"  Width="120px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="DeliveryPlace">
                                            <ItemTemplate>
                                                <asp:Label ID="lblDeliveryPlace" runat="server" Text='<%#Eval("DeliveryPlace") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="120px"  />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" VerticalAlign="Middle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="DeliveryMode">
                                            <ItemTemplate>
                                                <asp:Label ID="lblDeliveryMode" runat="server" Text='<%#Eval("DeliveryMode") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle"  Width="120px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Facepresentation">
                                            <ItemTemplate>
                                                <asp:Label ID="lblFacepresentation" runat="server" Text='<%#Eval("Facepresentation") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle"  Width="120px"  />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Deliveryrank">
                                            <ItemTemplate>
                                                <asp:Label ID="lblDeliveryrank" runat="server" Text='<%#Eval("Deliveryrank") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        
                                        <asp:TemplateField HeaderText="Apgarscore1min">
                                            <ItemTemplate>
                                                <asp:Label ID="lblApgarscore1min" runat="server" Text='<%#Eval("Apgarscore1min") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Apgarscore5min">
                                            <ItemTemplate>
                                                <asp:Label ID="lblApgarscore5min" runat="server" Text='<%#Eval("Apgarscore5min") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Apgarscore10min">
                                            <ItemTemplate>
                                                <asp:Label ID="lblApgarscore10min" runat="server" Text='<%#Eval("Apgarscore10min") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        
                                        <asp:TemplateField HeaderText="Condition">
                                            <ItemTemplate>
                                                <asp:Label ID="lblCondition" runat="server" Text='<%#Eval("Condition") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        
                        <asp:TemplateField HeaderText="Entry By">
                            <ItemTemplate>
                                <asp:Label ID="lblEntry" runat="server" Text='<%#Eval("EntryBy1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  Width="120px"  />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Entry Date">
                            <ItemTemplate>
                                <asp:Label ID="lblDate" runat="server" Text='<%#Util.GetDateTime(Eval("Date1")).ToString("dd-MMM-yyyy") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  Width="120px"  />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Entry Time">
                            <ItemTemplate>
                                <asp:Label ID="lblTime" runat="server" Text='<%#Util.GetDateTime(Eval("Time1")).ToString("hh:mm tt") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  Width="120px"  />
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
           
</form>
</body>
</html>

