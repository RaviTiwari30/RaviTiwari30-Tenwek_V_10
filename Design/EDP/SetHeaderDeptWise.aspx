<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="SetHeaderDeptWise.aspx.cs" Inherits="Design_EDP_ApprovalTypeMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        $(function () {
            //BindDepartment();           
        });

        function BindDepartment() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "services/EDP.asmx/BindDepartment",
                data: "{}",
                dataType: "json",
                success: function (result) {
                    Data = jQuery.parseJSON(result.d);
                    if (Data.length > 0) {
                        $('#<%=ddlDepartment.ClientID %>').empty();
                        $('#<%=ddlDepartment.ClientID %>').append($("<option></option>").val(0).html("Select"));
                        for (var i = 0; i < Data.length; i++) {
                            $('#<%=ddlDepartment.ClientID %>').append($("<option></option>").val(Data[i].Department).html(Data[i].Department));
                        }
                    }
                },
                error: function (error) {
                    alert(error);
                }
            });
        }


    </script>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Set Header Dept Wise</b>&nbsp;<br />
            <span id="spnErrorMsg" class="ItDoseLblError">
                <asp:Label ID="lblMsg" runat="server" Text=""></asp:Label>
            </span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="col-md-24">
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Department
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlDepartment" CssClass="requiredField" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlDepartment_SelectedIndexChanged"></asp:DropDownList>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Result
            </div>
            <table style="width: 100%">
                <tr>
                    <td class="trCondition">
                        <div style="overflow-y: scroll; height: 400px; width: 100%; text-align: left;" class="border">
                            <asp:GridView ID="grdHeader" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle" Width="100%">
                                <Columns>
                                    <asp:TemplateField>
                                        <HeaderTemplate>Select</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkheader" runat="server" Checked='<%# Util.GetBoolean(Eval("chk")) %>' />
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="S.No.">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Header Name">
                                        <ItemTemplate>
                                            <asp:Label ID="lblHeaderName" runat="server" Text='<%# Eval("HeaderName")%>' Width="200px"></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Seq. No.">
                                        <ItemTemplate>
                                            <asp:Label ID="lblHeaderId" runat="server" Text='<%# Eval("header_id")%>' Width="50px" Visible="false"></asp:Label>
                                            <asp:TextBox ID="txtSeqNo" runat="server" Text='<%# Eval("SeqNo")%>' Width="50px"></asp:TextBox>
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                        <table></table>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" CssClass="ItDoseButton" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" id="btnUpdate" value="Update" class="ItDoseButton" style="display: none" />
        </div>
    </div>
</asp:Content>

