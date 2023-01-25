<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="FullandFinal.aspx.cs" Inherits="Design_Payroll_FullandFinal" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        function CalculateRemuneration() {

            var basic = document.getElementById("ctl00$ContentPlaceHolder1$txtBasic").value;

            var hra = document.getElementById("ctl00$ContentPlaceHolder1$txtHRA").value;
            var Conveyance = document.getElementById("ctl00$ContentPlaceHolder1$txtConvAllowance").value;

            if (basic == "")
            { basic = "0"; }
            if (Conveyance == "")
            { Conveyance = "0"; }
            if (hra == "")
            { hra = "0"; }
            //alert(Conveyance);
            var Total = eval(basic) + eval(hra) + eval(Conveyance);
            //alert(Total);
            document.getElementById("ctl00$ContentPlaceHolder1$txtTotalRemuneration").value = Total;

        }
    </script>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Financial SetOff </b>
            <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <asp:Panel ID="tbl1" runat="server">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Search Criteria
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Employee ID 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtEmployeeID" runat="server" MaxLength="20" TabIndex="1"
                                    ToolTip="Enter Employee ID"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Employee Name 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtEmployeeName" runat="server" MaxLength="50" TabIndex="2"
                                    ToolTip="Enter Employee Name"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <asp:Button ID="btnSearch" runat="server" TabIndex="3" ToolTip="Click to Search"
                                    Text="Search" OnClick="btnSearch_Click" CssClass="ItDoseButton" Style="width: 100px" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Search Results
                </div>
                <div class="row">
                    <div class="col-md-22" align="center">
                        <asp:GridView ID="EmpGrid" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            OnRowCommand="EmpGrid_RowCommand">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="Emp_ID" HeaderText="Employee&nbsp;ID" ReadOnly="true">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="emp_name" HeaderText="Employee&nbsp;Name" ReadOnly="true">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="240px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Dept_Name" HeaderText="Department" ReadOnly="true">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="NoDuseDate" HeaderText="No&nbsp;Dues&nbsp;Date" ReadOnly="true">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Select">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbSelect" ToolTip="Click to Select" runat="server" ImageUrl="~/Images/Post.gif"
                                            CausesValidation="false" CommandArgument='<%# Eval("Emp_ID")+"#"+Eval("emp_name")+"#"+Eval("ID")%>'
                                            CommandName="Select" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>

                </div>

            </div>
        </asp:Panel>
        <asp:Panel ID="pnlHide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Employee Detail
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Employee ID 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:Label ID="lblEmployeeID" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Employee Name 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:Label ID="lblName" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Date Of Leaving 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtDOL" runat="server" TabIndex="4" ToolTip="Click to Select Date Of Leaving"></asp:TextBox>
                                <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtDOL" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Issue Date 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtIssueDate" runat="server" TabIndex="5" ToolTip="Click to Select  Issue Date"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtIssueDate"
                                    Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Final Settlement Amount
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtAmount" runat="server" MaxLength="8" TabIndex="6" ToolTip="Enter Final Settlement Amount"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="fc3" runat="server" FilterType="Custom,Numbers"
                                ValidChars="." FilterMode="validChars" TargetControlID="txtAmount">
                            </cc1:FilteredTextBoxExtender>
                                </div>
                        </div>
                    </div>

                </div>

            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:Label ID="lblID" runat="server" Visible="False"></asp:Label>
                <asp:Button ID="btnSave" ToolTip="Click to Save" CssClass="ItDoseButton" runat="server"
                    OnClick="btnSave_Click" Text="Save" ValidationGroup="v1" TabIndex="7" Style="margin-top: 7px; width: 100px"  />
                &nbsp;<asp:Button ID="btnUpdate" CssClass="ItDoseButton" ToolTip="Click to Update"
                    runat="server" Text="Update" OnClick="btnUpdate_Click" ValidationGroup="v1" TabIndex="8" Style="margin-top: 7px; width: 100px"  />
                <asp:Button ID="btncancel" CssClass="ItDoseButton" ToolTip="Click to Cancel" runat="server"
                    Text="Cancel" OnClick="btncancel_Click" TabIndex="9" Style="margin-top: 7px; width: 100px"  />
            </div>
        </asp:Panel>
    </div>
</asp:Content>
