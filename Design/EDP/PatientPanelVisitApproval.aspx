<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PatientPanelVisitApproval.aspx.cs" Inherits="Design_EDP_PatientPanelVisitApproval" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Src="~/Design/Controls/Time.ascx" TagName="StartTime" TagPrefix="uc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript">
        function validateSave() {
            if ($('#<%=lblPatientID.ClientID %>').text() == "") {

                modelAlert("Please Select Patient.", function () { });
                return false;
            }
            if ($('#<%=ddlPanel.ClientID %>').val() == "") {

                modelAlert("Please Select panel.", function () { });
                return false;
            }
            if ($('#<%=txtCardNo.ClientID %>').val() == "") {

                modelAlert("Please Select Card No.", function () { });
                return false;
            } 
            if ($('#<%=txtFromDate.ClientID %>').val() == "") {

                modelAlert("Please Select Valid From.", function () { });
                return false;
            }
            if ($('#<%=txtToDate.ClientID %>').val() == "") {

                modelAlert("Please Select Valid To.", function () { });
                return false;
            } 
            if ($('#<%=txtApproveAmount.ClientID %>').val() == "") {

                modelAlert("Please Fill Amount.", function () { });
                return false;
            }
            //return false;
        }
        function validateSearch()
        {
            if ($('#<%=txtPatientID.ClientID %>').val() == "")
            {
                modelAlert("Please fill Patient Id", function () { });
                return false;
            }
        }
    </script>
    <cc1:ToolkitScriptManager ID="toolScriptManageer1" runat="server"></cc1:ToolkitScriptManager> 
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Patient Panel Visit Approval</b><br />
                <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
              <div class="POuter_Box_Inventory">
                            <div class="row">
                                
                                <div class="col-md-3">
                                    <label class="pull-left"> Patient ID     </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtPatientID" runat="server"></asp:TextBox>
                                       
                                   </div>
                                
                                <div class="col-md-16">
                                    <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="ItDoseButton" ClientIDMode="Static" OnClientClick="return validateSearch();" TabIndex="69" OnClick="btnSearch_Click" />
                                    </div>
                                </div>
                  <div class="row">
                                <div class="col-md-24">
                                    <table style="width:100%;">
                                        <tr>
                                            <th class="GridViewHeaderStyle">Sr. No</th>
                                             <th class="GridViewHeaderStyle">Patient ID</th>
                                             <th class="GridViewHeaderStyle">Patient Name</th>
                                             <th class="GridViewHeaderStyle">Mobile No</th>
                                             <th class="GridViewHeaderStyle">Panel Name</th>
                                             <th class="GridViewHeaderStyle">Card No</th>
                                             <th class="GridViewHeaderStyle" style="width:150px;">LOU No</th>
                                             <th class="GridViewHeaderStyle">From Valid Date</th>
                                             <th class="GridViewHeaderStyle">To Valid Date</th>
                                             <th class="GridViewHeaderStyle">Approval Amt</th>
                                             <th class="GridViewHeaderStyle"></th>
                                        </tr>
                                        <tr>
                                            <td>1</td>
                                             <td>
                                                <asp:Label ID="lblPatientID" ClientIDMode="Static" runat="server" ></asp:Label>

                                             </td>
                                             <td>
                                                <asp:Label ID="lblPatientName" ClientIDMode="Static" runat="server" ></asp:Label></td>
                                             <td>
                                                 
                                                <asp:Label ID="lblMobileNo" ClientIDMode="Static" runat="server" ></asp:Label>
                                             </td>
                                             <td>
                                                 <asp:DropDownList id="ddlPanel" runat="server" DataValueField="PanelID" DataTextField="Company_Name" ></asp:DropDownList> 
                                             </td>
                                             <td>
                                                 
                                                                 <asp:TextBox ID="txtCardNo" runat="server"></asp:TextBox>
                                             </td>
                                            
                                             <td>
                                                 
                                                                 <asp:TextBox ID="txtLOUNo" runat="server" MaxLength="30"></asp:TextBox>
                                             </td>
                                             <td>
                                                 <asp:TextBox ID="txtFromDate" runat="server" Width="120" ></asp:TextBox>
                                       
                                      <cc1:CalendarExtender ID="caldate" PopupButtonID="ucFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"> </cc1:CalendarExtender> 
                                                   <uc2:StartTime ID="StartTime" runat="server" />
                                </td>
                                             <td>  <asp:TextBox ID="txtToDate" runat="server" Width="120"></asp:TextBox>
                                       
                                      <cc1:CalendarExtender ID="CalendarExtender1" PopupButtonID="ucFromDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"> </cc1:CalendarExtender> 
                                                   <uc2:StartTime ID="StartTime1" runat="server" />
                                </td>
                                             <td>
                                                 
                                <asp:TextBox ID="txtApproveAmount" runat="server"  Width="50px" ClientIDMode="Static"
                                     TabIndex="15" MaxLength="7" ToolTip="Enter Approve Amount"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender10" runat="server" TargetControlID="txtApproveAmount" ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                                             </td>
                                             <td><asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton" ClientIDMode="Static" OnClientClick="return validateSave();" TabIndex="69" OnClick="btnSave_Click" />
                                                 <asp:Button ID="btnUpdate" runat="server" Text="Update" Visible="false" ClientIDMode="Static" CssClass="ItDoseButton" TabIndex="69" OnClientClick="return validateSave();" OnClick="btnUpdate_Click" />
               
                                                   </td>
                                        </tr>
                                    </table>
                                    </div>
                      </div>
                  </div>
            
              <div class="POuter_Box_Inventory">
            <asp:GridView ID="grdPanel" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowCommand="grdPhysical_RowCommand" OnRowDataBound="grdPhysical_RowDataBound" TabIndex="6" Width="100%">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="PatientID">
                            <ItemTemplate>
                                <asp:Label ID="lblPatientID" runat="server" Text='<%#Eval("PatientID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        
                         <asp:TemplateField HeaderText="Patient Name">
                            <ItemTemplate>
                                <asp:Label ID="lblPatientName" runat="server" Text='<%#Eval("Pname") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Mobile No">
                            <ItemTemplate>
                                <asp:Label ID="lblMobile" runat="server" Text='<%#Eval("Mobile") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Panel Name">
                            <ItemTemplate>
                                <asp:Label ID="lblPanelName" runat="server" Text='<%#Eval("Company_Name") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Card Number">
                            <ItemTemplate>
                                <asp:Label ID="lblCardNumber" runat="server" Text='<%#Eval("CardNumber") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="LOU No">
                            <ItemTemplate>
                                <asp:Label ID="lblLOUNo" runat="server" Text='<%#Eval("LOUNo") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Valid From Date">
                            <ItemTemplate>
                                <asp:Label ID="lblFromDate" runat="server" Text='<%#Eval("FromValid1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Valid To Date">
                            <ItemTemplate>
                                <asp:Label ID="lblToDate" runat="server" Text='<%#Eval("ToValid1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Approve Amount">
                            <ItemTemplate>
                                <asp:Label ID="lblApproveAmount" runat="server" Text='<%# Util.GetDecimal( Eval("ApproveAmount")) == 0 ?  "" : Eval("ApproveAmount", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Entry By" Visible="true">
                            <ItemTemplate>
                                <asp:Label ID="lblEntryBy" runat="server" Text='<%#Eval("EntryBy1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Entry Date">
                            <ItemTemplate>
                                <asp:Label ID="lblEntryDate" runat="server" Text='<%#Eval("EntryDate1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <asp:Label ID="lblStatus" runat="server" Text='<%#Eval("Status") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>

 <asp:TemplateField HeaderText="Edit">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CausesValidation="false" CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/edit.png" runat="server" />
                                <asp:Label ID="lblID" Text='<%#Eval("ID1") %>' runat="server" Visible="false"></asp:Label>
                                                <asp:Label ID="lblTimeDiff" Text='<%#Eval("createdDateDiff") %>' runat="server" Visible="false"></asp:Label>
                                
                                <asp:Label ID="lblStatus1" runat="server" Text='<%#Eval("Status") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                  </div>
            

        </div>
            
       
</asp:Content>

