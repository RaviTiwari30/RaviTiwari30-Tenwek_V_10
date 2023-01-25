<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="EditEmployee.aspx.cs" Inherits="Design_Employee_EditEmployee" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript">
        function doClick(buttonName, e) {
            var key;
            if (window.event)
                key = window.event.keyCode;     //IE
            else
                key = e.which;     //firefox
            if (key == 13) {
                var btn = document.getElementById(buttonName);
                if (btn != null) { //If we find the button click it
                    btn.click();
                    event.keyCode = 0
                }
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Search Employee</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria&nbsp;
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Employee Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtName" runat="server" AutoCompleteType="Disabled" ToolTip="Enter Employee Name"
                                TabIndex="1" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="cmbDept" ToolTip="Select Department" runat="server" TabIndex="2">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">

                        <div class="col-md-8">
                        </div>
                        <div class="col-md-8">
                            <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" TabIndex="3" Text="Search"
                                OnClick="btnSearch_Click" ToolTip="Click To Search" />&nbsp;&nbsp;&nbsp;
                            <asp:Button ID="btnReport" runat="server" CssClass="ItDoseButton" Text="Report" OnClick="btnReport_Click" />
                        </div>
                        <div class="col-md-8">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="Purchaseheader">
                Employee Details
            </div>
            <asp:GridView ID="GridView1" runat="server" Width="100%" AutoGenerateColumns="False" OnPageIndexChanging="GridView1_PageIndexChanging"
                TabIndex="10" CssClass="GridViewStyle" AllowPaging="True" PageSize="20">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField HeaderText="S.No.">
                        <ItemTemplate>
                            <%# Container.DataItemIndex+1 %>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" Width="30px" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="Name" HeaderText="Employee&nbsp;Name">
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="250px" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="280px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="House_No" HeaderText="Address">
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="180px" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="220px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Mobile" HeaderText="Contact No.">
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="75px" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Phone" HeaderText="Phone" Visible="false">
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="75px" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Active" HeaderText="Active">
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="75px" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                    </asp:BoundField>
                    <asp:HyperLinkField HeaderText="Edit" Text="Edit" DataNavigateUrlFields="EmployeeID"
                        DataNavigateUrlFormatString="~/Design/Employee/EmployeeRegistration.aspx?EmployeeID={0}"
                        NavigateUrl="~/Design/Employee/EmployeeRegistration.aspx">
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="5px" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                    </asp:HyperLinkField>
                </Columns>
            </asp:GridView>
        </div>
</asp:Content>
