<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="Employee_Search.aspx.cs" Inherits="Design_Payroll_Employee_Search" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:content id="Content1" contentplaceholderid="ContentPlaceHolder1" runat="Server">
    
    <script type="text/javascript">
        function ReseizeIframe() {
            document.getElementById("iframePatient").style.width = "100%";
            document.getElementById("iframePatient").style.height = "100%";
            document.getElementById("iframePatient").style.display = "";
            document.getElementById("Pbody_box_inventory").style.display = 'none';
        }
        $(document).ready(function () {

            $("#<%=txtEmp_ID.ClientID %>").focus();
        });

            function check(e) {
                var keynum
                var keychar
                var numcheck
                // For Internet Explorer
                if (window.event) {
                    keynum = e.keyCode
                }
                    // For Netscape/Firefox/Opera
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                var card = $('#<%=txtEmp_ID.ClientID %>').val();
                if (card.charAt(0) == ' ') {
                    $('#<%=txtEmp_ID.ClientID %>').val('');
                    $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space');
                    return false;
                }
                var card = $('#<%=txtEmpName.ClientID %>').val();
                if (card.charAt(0) == ' ') {
                    $('#<%=txtEmpName.ClientID %>').val('');
                    $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space');
                    return false;
                }
                //List of special characters you want to restrict
                if (keychar == "'" || keychar == "`" || keychar == "!" || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "45") || (keynum >= "91" && keynum <= "95") || (keynum >= "58" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
                    return false;
                }

                else {
                    return true;
                }
            }
    </script>

    <div id="Pbody_box_inventory">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Employee Search </b>
            <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22" align="center">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Employee ID 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtEmp_ID" runat="server" MaxLength="20" TabIndex="1" ToolTip="Enter Employee ID" onkeypress="return check(event)"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Employee Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtEmpName" runat="server" MaxLength="50" TabIndex="2" ToolTip="Enter Employee Name" onkeypress="return check(event)"></asp:TextBox>
                                </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Department
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlDepartment" runat="server" TabIndex="3" ToolTip="Select Department">
                                    </asp:DropDownList>
                            </div>
                            </div>
                         <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Designation
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                             <div class="col-md-5">
                                  <asp:DropDownList ID="ddlDesignation" runat="server" TabIndex="4" ToolTip="Select Designation">
                                   </asp:DropDownList>
                                 </div>
                             <div class="col-md-3">
                                <label class="pull-left">
                                    Status
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                             <div class="col-md-5">
                                 <asp:DropDownList ID="DropDownList1" runat="server" TabIndex="5" ToolTip="Select Status">
                            <asp:ListItem Value="0,1">All</asp:ListItem>
                            <asp:ListItem Value="1" Selected="true">Active</asp:ListItem>
                            <asp:ListItem Value="0">Deactive</asp:ListItem>
                        </asp:DropDownList>
                                 </div>
                         </div>
                          </div>
                        </div>
            </div>
        <div class="POuter_Box_Inventory" align="center"> 
               <asp:Button ID="btnSearch" runat="server" TabIndex="6" ToolTip="Click to Search"
                            OnClick="btnSearch_Click" Text="Search" CssClass="ItDoseButton" style="margin-top:7px; width:100px;" />
            </div>
        <div class="POuter_Box_Inventory"> 
            <div class="Purchaseheader">
                Search Results
            </div>
            <div class="row">
                <div class="col-md-24">
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
                                <asp:BoundField ReadOnly="true" DataField="EmployeeID" HeaderText="Employee&nbsp;ID" Visible="false">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="center" Width="150px" />
                                </asp:BoundField>
                                <asp:BoundField ReadOnly="true" DataField="RegNo" HeaderText="Employee&nbsp;ID">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="center" Width="150px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Name" ReadOnly="true" HeaderText="Employee&nbsp;Name">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="center" Width="300px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Gender" HeaderText="Sex" ReadOnly="true">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="center" Width="80px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Desi_Name" HeaderText="Designation" ReadOnly="true">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="center" Width="200px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="dept_Name" HeaderText="Department" ReadOnly="true">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="center" Width="200px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="TotalEarning" HeaderText="Salary" ReadOnly="true" Visible="False">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="DOL" HeaderText="D.O.L." ReadOnly="true" Visible="False">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="center" />
                                </asp:BoundField>
                                <asp:TemplateField >
                                    <ItemTemplate>
                                        <a target="iframePatient" href="Employee_Registration.aspx?EmpID=<%#Eval("EmployeeID") %>"
                                            onclick="ReseizeIframe();">Personal</a>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="center" Width="100px" />
                                </asp:TemplateField>
                                <asp:TemplateField >
                                    <ItemTemplate>
                                        <a target="iframePatient" href="Employee_ProfessionalDetail_New.aspx?EmpID=<%#Eval("EmployeeID") %>"
                                            onclick="ReseizeIframe();">Professional</a>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="center" Width="100px" />
                                </asp:TemplateField>
                                <asp:TemplateField Visible="false">
                                    <ItemTemplate>
                                        <a target="iframePatient" href="FinanceSalary.aspx?EmpID=<%#Eval("EmployeeID") %>" onclick="ReseizeIframe();">Finance</a>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="center" Width="100px" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                </div>
            </div>
        </div>
    </div>
    <iframe id="iframePatient" name="iframePatient" src="" style="position: fixed; top: 0px; left: 0px; background-color: #FFFFFF; display: none;"
        frameborder="0" enableviewstate="true"></iframe>
</asp:content>
