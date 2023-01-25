<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Employee_Sms.aspx.cs" Inherits="Design_SMS_Employee_Sms" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        function validate() {
            if ($.trim($("#txtSMSText").val()) == "") {
                $("#lblMsg").text('Please Enter SMS Text');
                $("#txtSMSText").focus();
                return false;
            }
            if ($(".chk :checkbox:checked").length == 0) {
                $("#lblMsg").text('Please Select Doctor');
                return false;
            }
            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
             document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
             __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
         }

         $(document).ready(function () {
             $("#<% =txtSMSText.ClientID%>").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            $("#<%=txtSMSText.ClientID %>").bind("keyup keydown", function () {
                var characterInserted = $(this).val().length;
                if (characterInserted > 200) {
                    $(this).val($(this).val().substr(0, 200));
                }
                var characterRemaining = 200 - characterInserted;
            });



        });
    </script>
    <script type="text/javascript">
        function chkAll(rowID) {
            if ($(rowID).is(':checked')) {
                $('#<%=grdEMPSms.ClientID%>').find('tr').each(function (row) {
                    if ($(this).closest('tr').find("span[id*=lblMobile]").text() != "") {
                        $(this).closest('tr').find("input[id*=chkbox]:checkbox").attr("checked", "checked");
                    }
                });
            }
            else {
                $('#<%=grdEMPSms.ClientID%>').find('tr').each(function (row) {
                    $(this).closest('tr').find("input[id*=chkbox]:checkbox").removeAttr("checked");
                });
            }
        }


    </script>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>SMS For Employee</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td style="text-align: right; width: 20%">Employee Name :&nbsp; 
                    </td>
                    <td style="text-align: left; width: 30%">
                        <asp:DropDownList ID="ddlEmployee" runat="server"
                            ToolTip="Select Employee" Width="180px">
                        </asp:DropDownList>
                    </td>
                    <td style="width: 20%; text-align: right">&nbsp; 
                    </td>
                    <td style="text-align: left; width: 30%">&nbsp; 
                        
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search" OnClick="btnSearch_Click" />
        </div>
        <asp:Panel ID="pnlHide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="Purchaseheader">
                    Employee Details
                </div>
                <div style="overflow: auto; padding: 3px; width: 952px; height: 200px;">
                    <asp:GridView ID="grdEMPSms" runat="server" AutoGenerateColumns="False" OnRowDataBound="grdEMPSms_RowDataBound" ClientIDMode="Static"
                        CssClass="GridViewStyle">
                        <Columns>
                            <asp:TemplateField HeaderText="Select">
                                <HeaderTemplate>
                                    <asp:CheckBox ID="chkHeader" runat="server" CssClass="chkAll" ClientIDMode="Static" onclick="chkAll(this)" />
                                </HeaderTemplate>
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkbox" runat="server" CssClass="chk" />

                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Employee Name">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="320px" />
                                <ItemTemplate>
                                    <asp:Label ID="lblEmployee" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Name") %>'></asp:Label>
                                    <asp:Label ID="lblEmployeeID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"EmployeeID") %>' Visible="false"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Contact No.">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                <ItemTemplate>
                                    <asp:Label ID="lblMobile" ClientIDMode="Static" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Mobile") %>'></asp:Label>

                                </ItemTemplate>
                            </asp:TemplateField>


                        </Columns>
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    </asp:GridView>
                </div>
                <div style="overflow: auto; padding: 3px; width: 952px; height: 103px;">
                    <table style="width: 100%; border-collapse: collapse">
                        <tr>
                            <td style="text-align: right">SMS Text :&nbsp;
                            </td>
                            <td style="text-align: left">
                                <asp:TextBox ID="txtSMSText" ClientIDMode="Static" runat="server" TextMode="MultiLine" Height="87px" Width="509px"></asp:TextBox>

                            </td>
                        </tr>
                    </table>


                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" CssClass="ItDoseButton" OnClientClick="return validate()"></asp:Button>
            </div>
        </asp:Panel>
    </div>
</asp:Content>

