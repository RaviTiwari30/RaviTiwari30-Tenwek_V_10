<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CssdCountSheet.aspx.cs" Inherits="Design_OT_CssdCountSheet" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>

    <div id="Pbody_box_inventory" style="margin-top: 40px;">
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <b>Patient Count Sheet for CSSD Set</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                <asp:TextBox ID="txtUHId" runat="server" Visible="false"></asp:TextBox>
                <asp:TextBox ID="txtTransactionID" runat="server" Visible="false"></asp:TextBox>
                <asp:TextBox ID="txtSetId" runat="server" Visible="false"></asp:TextBox>
                <asp:TextBox ID="txtRequestId" runat="server" Visible="false"></asp:TextBox>

            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                    UHID :
                </div>
                <div class="col-md-5">
                    <asp:TextBox runat="server" ID="txtPatientID"></asp:TextBox>
                </div>

                <div class="col-md-3">
                    <asp:Button ID="btnSearchData" runat="server" OnClick="btnSearchData_Click" Text="Search" />
                </div>
            </div>

        </div>

        <div class="POuter_Box_Inventory" id="divSearchData" runat="server" visible="false">
            <asp:GridView ID="GridView1" Width="100%" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowCommand="GridView1_RowCommand">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField HeaderText="SN.">
                        <ItemTemplate>
                            <asp:Label ID="lblRowNumber" Text='<%# Container.DataItemIndex + 1 %>' runat="server" />
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Set Name">
                        <ItemTemplate>
                            <asp:Label ID="lblSetName" runat="server" Text='<%#Eval("SetName") %>'></asp:Label>
                            <asp:Label ID="lblSetID" runat="server" Text='<%#Eval("SetID") %>' Visible="false"></asp:Label>
                            <asp:Label ID="lblusedAgainstUHID" runat="server" Text='<%#Eval("usedAgainstUHID") %>' Visible="false"></asp:Label>
                             <asp:Label ID="lblusedAgainstTID" runat="server" Text='<%#Eval("usedAgainstTID") %>' Visible="false"></asp:Label>

                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Request Id">
                        <ItemTemplate>
                            <asp:Label ID="lblrequestId" runat="server" Text='<%#Eval("requestId") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Request Date">
                        <ItemTemplate>
                            <asp:Label ID="lblRequestedDateTime" runat="server" Text='<%#Eval("RequestedDateTime") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>
                    <asp:ButtonField CommandName="Select" Text="Select" ButtonType="Button" HeaderText="Select" HeaderStyle-CssClass="GridViewHeaderStyle" />

                </Columns>
            </asp:GridView>
        </div>

        <div id="divCountSheetDetails" runat="server" visible="false">
            <div class="POuter_Box_Inventory">
                <div style="text-align: center;">
                    <b>Count Sheet</b>

                </div>
            </div>
            <div id="tableHeader"></div>
            <div class="POuter_Box_Inventory" style="overflow: scroll;">
                <asp:GridView ID="grdDetail" Width="100%" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowDataBound="grdDetail_RowDataBound">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField>
                            <HeaderTemplate>
                                <asp:CheckBox ID="chkAll" runat="server" onclick="checkAll(this);"></asp:CheckBox>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:CheckBox ID="chk" runat="server" onclick="Check_Click(this)"></asp:CheckBox>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Set Name">
                            <ItemTemplate>
                                <asp:Label ID="lblSetName" runat="server" Text='<%#Eval("CdSetName") %>'></asp:Label>
                                <asp:Label ID="lblItemID" runat="server" Text='<%#Eval("CdItemId") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblusedAgainstTID" runat="server" Text='<%#Eval("usedAgainstTID") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblusedAgainstUHID" runat="server" Text='<%#Eval("usedAgainstUHID") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblrequestId" runat="server" Text='<%#Eval("requestId") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblSetID" runat="server" Text='<%#Eval("CdSetId") %>' Visible="false"></asp:Label>

                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Item Name">
                            <ItemTemplate>
                                <asp:Label ID="lblItemName" runat="server" Text='<%#Eval("CdItemName") %>'></asp:Label>

                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                        </asp:TemplateField>


                        <asp:TemplateField HeaderText="Pre">
                            <ItemTemplate>
                                <asp:TextBox ID="txtinitial" runat="server" Width="35px" MaxLength="9"
                                    Text='<%#Eval("initial") %>' AutoCompleteType="Disabled"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="fltinitial" runat="server" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txtinitial" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Additional">
                            <ItemTemplate>
                                <asp:TextBox ID="txtaddInitial1" runat="server" Width="35px" MaxLength="9"
                                    Text='<%#Eval("addInitial1") %>' AutoCompleteType="Disabled"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="fltinitial1" runat="server" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txtaddInitial1" />

                                <asp:TextBox ID="txtaddInitial2" runat="server" Width="35px" MaxLength="9"
                                    Text='<%#Eval("addInitial2") %>' AutoCompleteType="Disabled"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txtaddInitial2" />


                                <asp:TextBox ID="txtaddInitial3" runat="server" Width="35px" MaxLength="9"
                                    Text='<%#Eval("addInitial3") %>' AutoCompleteType="Disabled"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txtaddInitial3" />



                                <asp:TextBox ID="txtaddInitial4" runat="server" Width="35px" MaxLength="9"
                                    Text='<%#Eval("addInitial4") %>' AutoCompleteType="Disabled"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txtaddInitial4" />



                                <asp:TextBox ID="txtaddInitial5" runat="server" Width="35px" MaxLength="9"
                                    Text='<%#Eval("addInitial5") %>' AutoCompleteType="Disabled"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txtaddInitial5" />

                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Total">
                            <ItemTemplate>
                                <asp:TextBox ID="txttotal1" runat="server" Text='<%#Eval("Total1") %>' Width="50px"></asp:TextBox>

                                <cc1:FilteredTextBoxExtender ID="flttxttotal1" runat="server" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txttotal1" />

                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Post">
                            <ItemTemplate>
                                <asp:TextBox ID="txtFirst" runat="server" Width="35px" MaxLength="9"
                                    Text='<%#Eval("CountFirst") %>' AutoCompleteType="Disabled"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="fltFirst" runat="server" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txtFirst" />

                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Additional">
                            <ItemTemplate>
                                <asp:TextBox ID="txtFistAdd1" runat="server" Width="35px" MaxLength="9"
                                    Text='<%#Eval("FistAdd1") %>' AutoCompleteType="Disabled"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="flttxtFistAdd1" runat="server" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txtFistAdd1" />


                                <asp:TextBox ID="txtFistAdd2" runat="server" Width="35px" MaxLength="9"
                                    Text='<%#Eval("FistAdd2") %>' AutoCompleteType="Disabled"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txtFistAdd2" />


                                <asp:TextBox ID="txtFistAdd3" runat="server" Width="35px" MaxLength="9"
                                    Text='<%#Eval("FistAdd3") %>' AutoCompleteType="Disabled"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender6" runat="server" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txtFistAdd3" />



                                <asp:TextBox ID="txtFistAdd4" runat="server" Width="35px" MaxLength="9"
                                    Text='<%#Eval("FistAdd4") %>' AutoCompleteType="Disabled"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender7" runat="server" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txtFistAdd4" />

                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="160px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Total">
                            <ItemTemplate>
                                <asp:TextBox ID="txtTotal2" runat="server" Width="35px" MaxLength="9"
                                    Text='<%#Eval("Total2") %>' AutoCompleteType="Disabled"></asp:TextBox>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Second" Visible="false">
                            <ItemTemplate>
                                <asp:TextBox ID="txtSecond" runat="server" Width="35px" MaxLength="9"
                                    Text='<%#Eval("CountSecond") %>' AutoCompleteType="Disabled"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender8" runat="server" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txtSecond" />

                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Final" Visible="false">
                            <ItemTemplate>
                                <asp:TextBox ID="txtFinal" runat="server" Width="35px" MaxLength="9"
                                    Text='<%#Eval("Final") %>' AutoCompleteType="Disabled"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender9" runat="server" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txtFinal" />

                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
            <div class="POuter_Box_Inventory">
                <div style="text-align: center;">
                    <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" Text="Save" OnClick="btnSave_Click" />
                    &nbsp;<asp:Button ID="btnPrint" CssClass="ItDoseButton" runat="server" TabIndex="79"
                        Text="Print" Visible="false" />
                </div>
            </div>

        </div>
    </div>




































    <script type="text/javascript">
        $(document).ready(function () {
            $("table[id*=grdDetail] input[type=text][id*=txtinitial]").blur(function () {
                var price1 = 0.00;
                var price2 = 0.00;
                var price3 = 0.00;
                var price4 = 0.00;
                var price5 = 0.00;
                if (($(this).closest("tr").find("input[id*=txtinitial]").val() == "0") || ($(this).closest("tr").find("input[id*=txtinitial]").val().charAt(0) == "0")) {
                    $(this).closest("tr").find("input[id*=txtinitial]").val('1');
                    if ($(this).closest("tr").find("input[id*=txtinitial]").val() == "") {
                        $(this).closest("tr").find("input[id*=txtinitial]").val(' ');
                    }
                    total = 0;
                    var q = parseFloat($(this).val());

                    if (isNaN(q)) q = 0;
                    if (($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val().charAt(0) != "0")) {
                        price1 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial1]").val());

                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val().charAt(0) != "0")) {
                        price2 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial2]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val().charAt(0) != "0")) {
                        price3 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial3]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val().charAt(0) != "0")) {
                        price4 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial4]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val().charAt(0) != "0")) {
                        price5 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial5]").val());
                    }


                    if (total == "0") {
                        $(this).closest("tr").find("input[id*=txttotal1]").val("");
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txttotal1]").val(q + price1 + price2 + price3 + price4 + price5);
                    }
                    $("input[id*=txttotal1]").each(function (index, item) {
                        tempAmount = parseFloat($(item).val());
                        if (isNaN(tempAmount)) tempAmount = 0;
                        total = total + tempAmount;
                    });
                }

                total = 0.00;
                var q = parseFloat($(this).val());

                if (isNaN(q)) q = 0;
                if (($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val().charAt(0) != "0")) {
                    price1 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial1]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val().charAt(0) != "0")) {
                    price2 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial2]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val().charAt(0) != "0")) {
                    price3 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial3]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val().charAt(0) != "0")) {
                    price4 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial4]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val().charAt(0) != "0")) {
                    price5 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial5]").val());
                }
                var total = parseFloat(q + price1 + price2 + price3 + price4 + price5);
                if (total == "0") {
                    $(this).closest("tr").find("input[id*=txttotal1]").val("");
                }
                else {
                    $(this).closest("tr").find("input[id*=txttotal1]").val(q + price1 + price2 + price3 + price4 + price5);
                }
                $("input[id*=txttotal1]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    total = total + tempAmount;

                });
                total = total.toFixed(2);

            });
            $("table[id*=grdDetail] input[type=text][id*=txtaddInitial1]").blur(function () {
                var price1 = 0.00;
                var price2 = 0.00;
                var price3 = 0.00;
                var price4 = 0.00;
                var price5 = 0.00;
                if (($(this).closest("tr").find("input[id*=txtaddInitial1]").val() == "0") || ($(this).closest("tr").find("input[id*=txtaddInitial1]").val().charAt(0) == "0")) {
                    $(this).closest("tr").find("input[id*=txtaddInitial1]").val('1');
                    if ($(this).closest("tr").find("input[id*=txtaddInitial1]").val() == "") {
                        $(this).closest("tr").find("input[id*=txtaddInitial1]").val(' ');
                    }
                    total = 0;
                    var q = parseFloat($(this).val());
                    if (isNaN(q)) q = 0;
                    if (($(this).closest("tr").find("input[id*=txtinitial]").val() != "0") && ($(this).closest("tr").find("input[id*=txtinitial]").val() != "") && ($(this).closest("tr").find("input[id*=txtinitial]").val().charAt(0) != "0")) {

                        price1 = parseFloat($(this).closest("tr").find("input[id*=txtinitial]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val().charAt(0) != "0")) {
                        price2 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial2]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val().charAt(0) != "0")) {
                        price3 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial3]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val().charAt(0) != "0")) {
                        price4 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial4]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val().charAt(0) != "0")) {
                        price5 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial5]").val());
                    }

                    if (total == "0") {
                        $(this).closest("tr").find("input[id*=txttotal1]").val("");
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txttotal1]").val(q + price1 + price2 + price3 + price4 + price5);
                    }
                    $("input[id*=txttotal1]").each(function (index, item) {
                        tempAmount = parseFloat($(item).val());
                        if (isNaN(tempAmount)) tempAmount = 0;
                        total = total + tempAmount;
                    });
                }

                total = 0.00;
                var q = parseFloat($(this).val());
                if (isNaN(q)) q = 0;
                if (($(this).closest("tr").find("input[id*=txtinitial]").val() != "0") && ($(this).closest("tr").find("input[id*=txtinitial]").val() != "") && ($(this).closest("tr").find("input[id*=txtinitial]").val().charAt(0) != "0")) {

                    price1 = parseFloat($(this).closest("tr").find("input[id*=txtinitial]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val().charAt(0) != "0")) {
                    price2 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial2]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val().charAt(0) != "0")) {
                    price3 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial3]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val().charAt(0) != "0")) {
                    price4 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial4]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val().charAt(0) != "0")) {
                    price5 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial5]").val());
                }

                var total = parseFloat(q + price1 + price2 + price3 + price4 + price5);

                if (total == "0") {
                    $(this).closest("tr").find("input[id*=txttotal1]").val("");
                }
                else {
                    $(this).closest("tr").find("input[id*=txttotal1]").val(q + price1 + price2 + price3 + price4 + price5);
                }
                $("input[id*=txttotal1]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    total = total + tempAmount;

                });
                total = total.toFixed(2);

            });
            $("table[id*=grdDetail] input[type=text][id*=txtaddInitial2]").blur(function () {
                var price1 = 0.00;
                var price2 = 0.00;
                var price3 = 0.00;
                var price4 = 0.00;
                var price5 = 0.00;
                if (($(this).closest("tr").find("input[id*=txtaddInitial2]").val() == "0") || ($(this).closest("tr").find("input[id*=txtaddInitial2]").val().charAt(0) == "0")) {
                    $(this).closest("tr").find("input[id*=txtaddInitial2]").val('1');
                    if ($(this).closest("tr").find("input[id*=txtaddInitial2]").val() == "") {
                        $(this).closest("tr").find("input[id*=txtaddInitial2]").val(' ');
                    }
                    total = 0;
                    var q = parseFloat($(this).val());
                    if (isNaN(q)) q = 0;
                    if (($(this).closest("tr").find("input[id*=txtinitial]").val() != "0") && ($(this).closest("tr").find("input[id*=txtinitial]").val() != "") && ($(this).closest("tr").find("input[id*=txtinitial]").val().charAt(0) != "0")) {

                        price1 = parseFloat($(this).closest("tr").find("input[id*=txtinitial]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val().charAt(0) != "0")) {
                        price2 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial1]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val().charAt(0) != "0")) {
                        price3 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial3]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val().charAt(0) != "0")) {
                        price4 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial4]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val().charAt(0) != "0")) {
                        price5 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial5]").val());
                    }


                    if (total == "0") {
                        $(this).closest("tr").find("input[id*=txttotal1]").val("");
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txttotal1]").val(q + price1 + price2 + price3 + price4 + price5);
                    }
                    $("input[id*=txttotal1]").each(function (index, item) {
                        tempAmount = parseFloat($(item).val());
                        if (isNaN(tempAmount)) tempAmount = 0;
                        total = total + tempAmount;
                    });
                }

                total = 0.00;
                var q = parseFloat($(this).val());
                if (isNaN(q)) q = 0;
                if (($(this).closest("tr").find("input[id*=txtinitial]").val() != "0") && ($(this).closest("tr").find("input[id*=txtinitial]").val() != "") && ($(this).closest("tr").find("input[id*=txtinitial]").val().charAt(0) != "0")) {

                    price1 = parseFloat($(this).closest("tr").find("input[id*=txtinitial]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val().charAt(0) != "0")) {
                    price2 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial1]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val().charAt(0) != "0")) {
                    price3 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial3]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val().charAt(0) != "0")) {
                    price4 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial4]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val().charAt(0) != "0")) {
                    price5 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial5]").val());
                }

                var total = parseFloat(q + price1 + price2 + price3 + price4 + price5);
                if (total == "0") {
                    $(this).closest("tr").find("input[id*=txttotal1]").val("");
                }
                else {
                    $(this).closest("tr").find("input[id*=txttotal1]").val(q + price1 + price2 + price3 + price4 + price5);
                }
                $("input[id*=txttotal1]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    total = total + tempAmount;

                });
                total = total.toFixed(2);

            });
            $("table[id*=grdDetail] input[type=text][id*=txtaddInitial3]").blur(function () {
                var price1 = 0.00;
                var price2 = 0.00;
                var price3 = 0.00;
                var price4 = 0.00;
                var price5 = 0.00;
                if (($(this).closest("tr").find("input[id*=txtaddInitial3]").val() == "0") || ($(this).closest("tr").find("input[id*=txtaddInitial3]").val().charAt(0) == "0")) {
                    $(this).closest("tr").find("input[id*=txtaddInitial3]").val('1');
                    if ($(this).closest("tr").find("input[id*=txtaddInitial3]").val() == "") {
                        $(this).closest("tr").find("input[id*=txtaddInitial3]").val(' ');
                    }
                    total = 0;
                    var q = parseFloat($(this).val());
                    if (isNaN(q)) q = 0;
                    if (($(this).closest("tr").find("input[id*=txtinitial]").val() != "0") && ($(this).closest("tr").find("input[id*=txtinitial]").val() != "") && ($(this).closest("tr").find("input[id*=txtinitial]").val().charAt(0) != "0")) {

                        price1 = parseFloat($(this).closest("tr").find("input[id*=txtinitial]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val().charAt(0) != "0")) {
                        price2 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial1]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val().charAt(0) != "0")) {
                        price3 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial2]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val().charAt(0) != "0")) {
                        price4 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial4]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val().charAt(0) != "0")) {
                        price5 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial5]").val());
                    }


                    if (total == "0") {
                        $(this).closest("tr").find("input[id*=txttotal1]").val("");
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txttotal1]").val(q + price1 + price2 + price3 + price4 + price5);
                    }
                    $("input[id*=txttotal1]").each(function (index, item) {
                        tempAmount = parseFloat($(item).val());
                        if (isNaN(tempAmount)) tempAmount = 0;
                        total = total + tempAmount;
                    });
                }

                total = 0.00;
                var q = parseFloat($(this).val());
                if (isNaN(q)) q = 0;
                if (($(this).closest("tr").find("input[id*=txtinitial]").val() != "0") && ($(this).closest("tr").find("input[id*=txtinitial]").val() != "") && ($(this).closest("tr").find("input[id*=txtinitial]").val().charAt(0) != "0")) {

                    price1 = parseFloat($(this).closest("tr").find("input[id*=txtinitial]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val().charAt(0) != "0")) {
                    price2 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial1]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val().charAt(0) != "0")) {
                    price3 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial2]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val().charAt(0) != "0")) {
                    price4 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial4]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val().charAt(0) != "0")) {
                    price5 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial5]").val());
                }

                var total = parseFloat(q + price1 + price2 + price3 + price4 + price5);
                if (total == "0") {
                    $(this).closest("tr").find("input[id*=txttotal1]").val("");
                }
                else {
                    $(this).closest("tr").find("input[id*=txttotal1]").val(q + price1 + price2 + price3 + price4 + price5);
                }
                $("input[id*=txttotal1]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    total = total + tempAmount;

                });
                total = total.toFixed(2);

            });
            $("table[id*=grdDetail] input[type=text][id*=txtaddInitial4]").blur(function () {
                var price1 = 0.00;
                var price2 = 0.00;
                var price3 = 0.00;
                var price4 = 0.00;
                var price5 = 0.00;
                if (($(this).closest("tr").find("input[id*=txtaddInitial4]").val() == "0") || ($(this).closest("tr").find("input[id*=txtaddInitial4]").val().charAt(0) == "0")) {
                    $(this).closest("tr").find("input[id*=txtaddInitial4]").val('1');
                    if ($(this).closest("tr").find("input[id*=txtaddInitial4]").val() == "") {
                        $(this).closest("tr").find("input[id*=txtaddInitial4]").val(' ');
                    }
                    total = 0;
                    var q = parseFloat($(this).val());
                    if (isNaN(q)) q = 0;
                    if (($(this).closest("tr").find("input[id*=txtinitial]").val() != "0") && ($(this).closest("tr").find("input[id*=txtinitial]").val() != "") && ($(this).closest("tr").find("input[id*=txtinitial]").val().charAt(0) != "0")) {

                        price1 = parseFloat($(this).closest("tr").find("input[id*=txtinitial]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val().charAt(0) != "0")) {
                        price2 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial1]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val().charAt(0) != "0")) {
                        price3 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial2]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val().charAt(0) != "0")) {
                        price4 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial3]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val().charAt(0) != "0")) {
                        price5 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial5]").val());
                    }


                    if (total == "0") {
                        $(this).closest("tr").find("input[id*=txttotal1]").val("");
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txttotal1]").val(q + price1 + price2 + price3 + price4 + price5);
                    }
                    $("input[id*=txttotal1]").each(function (index, item) {
                        tempAmount = parseFloat($(item).val());
                        if (isNaN(tempAmount)) tempAmount = 0;
                        total = total + tempAmount;
                    });
                }

                total = 0.00;
                var q = parseFloat($(this).val());
                if (isNaN(q)) q = 0;
                if (($(this).closest("tr").find("input[id*=txtinitial]").val() != "0") && ($(this).closest("tr").find("input[id*=txtinitial]").val() != "") && ($(this).closest("tr").find("input[id*=txtinitial]").val().charAt(0) != "0")) {

                    price1 = parseFloat($(this).closest("tr").find("input[id*=txtinitial]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val().charAt(0) != "0")) {
                    price2 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial1]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val().charAt(0) != "0")) {
                    price3 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial2]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val().charAt(0) != "0")) {
                    price4 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial3]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial5]").val().charAt(0) != "0")) {
                    price5 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial5]").val());
                }

                var total = parseFloat(q + price1 + price2 + price3 + price4 + price5);
                if (total == "0") {
                    $(this).closest("tr").find("input[id*=txttotal1]").val("");
                }
                else {
                    $(this).closest("tr").find("input[id*=txttotal1]").val(q + price1 + price2 + price3 + price4 + price5);
                }
                $("input[id*=txttotal1]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    total = total + tempAmount;

                });
                total = total.toFixed(2);

            });
            $("table[id*=grdDetail] input[type=text][id*=txtaddInitial5]").blur(function () {
                var price1 = 0.00;
                var price2 = 0.00;
                var price3 = 0.00;
                var price4 = 0.00;
                var price5 = 0.00;
                if (($(this).closest("tr").find("input[id*=txtaddInitial5]").val() == "0") || ($(this).closest("tr").find("input[id*=txtaddInitial5]").val().charAt(0) == "0")) {
                    $(this).closest("tr").find("input[id*=txtaddInitial5]").val('1');
                    if ($(this).closest("tr").find("input[id*=txtaddInitial5]").val() == "") {
                        $(this).closest("tr").find("input[id*=txtaddInitial5]").val(' ');
                    }
                    total = 0;
                    var q = parseFloat($(this).val());
                    if (isNaN(q)) q = 0;
                    if (($(this).closest("tr").find("input[id*=txtinitial]").val() != "0") && ($(this).closest("tr").find("input[id*=txtinitial]").val() != "") && ($(this).closest("tr").find("input[id*=txtinitial]").val().charAt(0) != "0")) {
                        price1 = parseFloat($(this).closest("tr").find("input[id*=txtinitial]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val().charAt(0) != "0")) {
                        price2 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial1]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val().charAt(0) != "0")) {
                        price3 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial2]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val().charAt(0) != "0")) {
                        price4 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial3]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val().charAt(0) != "0")) {
                        price5 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial4]").val());
                    }


                    if (total == "0") {
                        $(this).closest("tr").find("input[id*=txttotal1]").val("");
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txttotal1]").val(q + price1 + price2 + price3 + price4 + price5);
                    }
                    $("input[id*=txttotal1]").each(function (index, item) {
                        tempAmount = parseFloat($(item).val());
                        if (isNaN(tempAmount)) tempAmount = 0;
                        total = total + tempAmount;
                    });
                }

                total = 0.00;
                var q = parseFloat($(this).val());
                if (isNaN(q)) q = 0;
                if (($(this).closest("tr").find("input[id*=txtinitial]").val() != "0") && ($(this).closest("tr").find("input[id*=txtinitial]").val() != "") && ($(this).closest("tr").find("input[id*=txtinitial]").val().charAt(0) != "0")) {

                    price1 = parseFloat($(this).closest("tr").find("input[id*=txtinitial]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial1]").val().charAt(0) != "0")) {
                    price2 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial1]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial2]").val().charAt(0) != "0")) {
                    price3 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial2]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial3]").val().charAt(0) != "0")) {
                    price4 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial3]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val() != "") && ($(this).closest("tr").find("input[id*=txtaddInitial4]").val().charAt(0) != "0")) {
                    price5 = parseFloat($(this).closest("tr").find("input[id*=txtaddInitial4]").val());
                }

                var total = parseFloat(q + price1 + price2 + price3 + price4 + price5);
                if (total == "0") {
                    $(this).closest("tr").find("input[id*=txttotal1]").val("");
                }
                else {
                    $(this).closest("tr").find("input[id*=txttotal1]").val(q + price1 + price2 + price3 + price4 + price5);
                }
                $("input[id*=txttotal1]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    total = total + tempAmount;

                });
                total = total.toFixed(2);

            });
        });

        $(document).ready(function () {
            $("table[id*=grdDetail] input[type=text][id*=txtFirst]").blur(function () {
                var price1 = 0.00;
                var price2 = 0.00;
                var price3 = 0.00;
                var price4 = 0.00;
                var price5 = 0.00;
                if (($(this).closest("tr").find("input[id*=txtFirst]").val() == "0") || ($(this).closest("tr").find("input[id*=txtFirst]").val().charAt(0) == "0")) {
                    $(this).closest("tr").find("input[id*=txtFirst]").val('1');
                    if ($(this).closest("tr").find("input[id*=txtFirst]").val() == "") {
                        $(this).closest("tr").find("input[id*=txtFirst]").val(' ');
                    }
                    total = 0;
                    var q = parseFloat($(this).val());
                    if (isNaN(q)) q = 0;
                    if (($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val().charAt(0) != "0")) {
                        price1 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd1]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val().charAt(0) != "0")) {
                        price2 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd2]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val().charAt(0) != "0")) {
                        price3 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd3]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val().charAt(0) != "0")) {
                        price4 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd4]").val());
                    }

                    if (total == "0") {
                        $(this).closest("tr").find("input[id*=txtTotal2]").val("");
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txtTotal2]").val(q + price1 + price2 + price3 + price4);
                    }
                    if (($(this).closest("tr").find("input[id*=txtSecond]").val() != "0") && ($(this).closest("tr").find("input[id*=txtSecond]").val() != "") && ($(this).closest("tr").find("input[id*=txtSecond]").val().charAt(0) != "0")) {
                        price5 = parseFloat($(this).closest("tr").find("input[id*=txtSecond]").val());
                    }

                    var final = parseFloat(total + price5);
                    if (final == "0") {
                        $(this).closest("tr").find("input[id*=txtFinal]").val(total);
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txtFinal]").val(final);
                    }
                    $("input[id*=txtTotal2]").each(function (index, item) {
                        tempAmount = parseFloat($(item).val());
                        if (isNaN(tempAmount)) tempAmount = 0;
                        total = total + tempAmount;
                    });
                }

                total = 0.00;
                var q = parseFloat($(this).val());
                if (isNaN(q)) q = 0;
                if (($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val().charAt(0) != "0")) {
                    price1 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd1]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val().charAt(0) != "0")) {
                    price2 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd2]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val().charAt(0) != "0")) {
                    price3 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd3]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val().charAt(0) != "0")) {
                    price4 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd4]").val());
                }

                var total = parseFloat(q + price1 + price2 + price3 + price4);
                if (total == "0") {
                    $(this).closest("tr").find("input[id*=txtTotal2]").val("");
                }
                else {
                    $(this).closest("tr").find("input[id*=txtTotal2]").val(q + price1 + price2 + price3 + price4);
                }
                if (($(this).closest("tr").find("input[id*=txtSecond]").val() != "0") && ($(this).closest("tr").find("input[id*=txtSecond]").val() != "") && ($(this).closest("tr").find("input[id*=txtSecond]").val().charAt(0) != "0")) {
                    price5 = parseFloat($(this).closest("tr").find("input[id*=txtSecond]").val());
                }

                var final = parseFloat(total + price5);
                if (final == "0") {
                    $(this).closest("tr").find("input[id*=txtFinal]").val(total);
                }
                else {
                    $(this).closest("tr").find("input[id*=txtFinal]").val(final);
                }
                $("input[id*=txtTotal2]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    total = total + tempAmount;

                });
                total = total.toFixed(2);

            });
            $("table[id*=grdDetail] input[type=text][id*=txtFistAdd1]").blur(function () {
                var price1 = 0.00;
                var price2 = 0.00;
                var price3 = 0.00;
                var price4 = 0.00;
                var price5 = 0.00;
                if (($(this).closest("tr").find("input[id*=txtFistAdd1]").val() == "0") || ($(this).closest("tr").find("input[id*=txtFistAdd1]").val().charAt(0) == "0")) {
                    $(this).closest("tr").find("input[id*=txtFistAdd1]").val('1');
                    if ($(this).closest("tr").find("input[id*=txtFistAdd1]").val() == "") {
                        $(this).closest("tr").find("input[id*=txtFistAdd1]").val(' ');
                    }
                    total = 0;
                    var q = parseFloat($(this).val());
                    if (isNaN(q)) q = 0;
                    if (($(this).closest("tr").find("input[id*=txtFirst]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFirst]").val() != "") && ($(this).closest("tr").find("input[id*=txtFirst]").val().charAt(0) != "0")) {
                        price1 = parseFloat($(this).closest("tr").find("input[id*=txtFirst]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val().charAt(0) != "0")) {
                        price2 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd2]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val().charAt(0) != "0")) {
                        price3 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd3]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val().charAt(0) != "0")) {
                        price4 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd4]").val());
                    }

                    if (total == "0") {
                        $(this).closest("tr").find("input[id*=txtTotal2]").val("");
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txtTotal2]").val(q + price1 + price2 + price3 + price4);
                    }
                    if (($(this).closest("tr").find("input[id*=txtSecond]").val() != "0") && ($(this).closest("tr").find("input[id*=txtSecond]").val() != "") && ($(this).closest("tr").find("input[id*=txtSecond]").val().charAt(0) != "0")) {
                        price5 = parseFloat($(this).closest("tr").find("input[id*=txtSecond]").val());
                    }

                    var final = parseFloat(total + price5);
                    if (final == "0") {
                        $(this).closest("tr").find("input[id*=txtFinal]").val(total);
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txtFinal]").val(final);
                    }
                    $("input[id*=txtTotal2]").each(function (index, item) {
                        tempAmount = parseFloat($(item).val());
                        if (isNaN(tempAmount)) tempAmount = 0;
                        total = total + tempAmount;
                    });
                }

                total = 0.00;
                var q = parseFloat($(this).val());
                if (isNaN(q)) q = 0;
                if (($(this).closest("tr").find("input[id*=txtFirst]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFirst]").val() != "") && ($(this).closest("tr").find("input[id*=txtFirst]").val().charAt(0) != "0")) {
                    price1 = parseFloat($(this).closest("tr").find("input[id*=txtFirst]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val().charAt(0) != "0")) {
                    price2 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd2]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val().charAt(0) != "0")) {
                    price3 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd3]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val().charAt(0) != "0")) {
                    price4 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd4]").val());
                }

                var total = parseFloat(q + price1 + price2 + price3 + price4);
                if (total == "0") {
                    $(this).closest("tr").find("input[id*=txtTotal2]").val("");
                }
                else {
                    $(this).closest("tr").find("input[id*=txtTotal2]").val(q + price1 + price2 + price3 + price4);
                }
                if (($(this).closest("tr").find("input[id*=txtSecond]").val() != "0") && ($(this).closest("tr").find("input[id*=txtSecond]").val() != "") && ($(this).closest("tr").find("input[id*=txtSecond]").val().charAt(0) != "0")) {
                    price5 = parseFloat($(this).closest("tr").find("input[id*=txtSecond]").val());
                }

                var final = parseFloat(total + price5);
                if (final == "0") {
                    $(this).closest("tr").find("input[id*=txtFinal]").val(total);
                }
                else {
                    $(this).closest("tr").find("input[id*=txtFinal]").val(final);
                }
                $("input[id*=txtTotal2]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    total = total + tempAmount;

                });
                total = total.toFixed(2);
            });
            $("table[id*=grdDetail] input[type=text][id*=txtFistAdd2]").blur(function () {
                var price1 = 0.00;
                var price2 = 0.00;
                var price3 = 0.00;
                var price4 = 0.00;
                var price5 = 0.00;
                if (($(this).closest("tr").find("input[id*=txtFistAdd2]").val() == "0") || ($(this).closest("tr").find("input[id*=txtFistAdd2]").val().charAt(0) == "0")) {
                    $(this).closest("tr").find("input[id*=txtFistAdd2]").val('1');
                    if ($(this).closest("tr").find("input[id*=txtFistAdd2]").val() == "") {
                        $(this).closest("tr").find("input[id*=txtFistAdd2]").val(' ');
                    }
                    total = 0;
                    var q = parseFloat($(this).val());
                    if (isNaN(q)) q = 0;
                    if (($(this).closest("tr").find("input[id*=txtFirst]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFirst]").val() != "") && ($(this).closest("tr").find("input[id*=txtFirst]").val().charAt(0) != "0")) {
                        price1 = parseFloat($(this).closest("tr").find("input[id*=txtFirst]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val().charAt(0) != "0")) {
                        price2 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd1]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val().charAt(0) != "0")) {
                        price3 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd3]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val().charAt(0) != "0")) {
                        price4 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd4]").val());
                    }

                    if (total == "0") {
                        $(this).closest("tr").find("input[id*=txtTotal2]").val("");
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txtTotal2]").val(q + price1 + price2 + price3 + price4);
                    }
                    if (($(this).closest("tr").find("input[id*=txtSecond]").val() != "0") && ($(this).closest("tr").find("input[id*=txtSecond]").val() != "") && ($(this).closest("tr").find("input[id*=txtSecond]").val().charAt(0) != "0")) {
                        price5 = parseFloat($(this).closest("tr").find("input[id*=txtSecond]").val());
                    }

                    var final = parseFloat(total + price5);
                    if (final == "0") {
                        $(this).closest("tr").find("input[id*=txtFinal]").val(total);
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txtFinal]").val(final);
                    }
                    $("input[id*=txtTotal2]").each(function (index, item) {
                        tempAmount = parseFloat($(item).val());
                        if (isNaN(tempAmount)) tempAmount = 0;
                        total = total + tempAmount;
                    });
                }

                total = 0.00;
                var q = parseFloat($(this).val());
                if (isNaN(q)) q = 0;
                if (($(this).closest("tr").find("input[id*=txtFirst]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFirst]").val() != "") && ($(this).closest("tr").find("input[id*=txtFirst]").val().charAt(0) != "0")) {
                    price1 = parseFloat($(this).closest("tr").find("input[id*=txtFirst]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val().charAt(0) != "0")) {
                    price2 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd1]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val().charAt(0) != "0")) {
                    price3 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd3]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val().charAt(0) != "0")) {
                    price4 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd4]").val());
                }

                var total = parseFloat(q + price1 + price2 + price3 + price4);
                if (total == "0") {
                    $(this).closest("tr").find("input[id*=txtTotal2]").val("");
                }
                else {
                    $(this).closest("tr").find("input[id*=txtTotal2]").val(q + price1 + price2 + price3 + price4);
                }
                if (($(this).closest("tr").find("input[id*=txtSecond]").val() != "0") && ($(this).closest("tr").find("input[id*=txtSecond]").val() != "") && ($(this).closest("tr").find("input[id*=txtSecond]").val().charAt(0) != "0")) {
                    price5 = parseFloat($(this).closest("tr").find("input[id*=txtSecond]").val());
                }

                var final = parseFloat(total + price5);
                if (final == "0") {
                    $(this).closest("tr").find("input[id*=txtFinal]").val(total);
                }
                else {
                    $(this).closest("tr").find("input[id*=txtFinal]").val(final);
                }
                $("input[id*=txtTotal2]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    total = total + tempAmount;

                });
                total = total.toFixed(2);
            });

            $("table[id*=grdDetail] input[type=text][id*=txtFistAdd3]").blur(function () {
                var price1 = 0.00;
                var price2 = 0.00;
                var price3 = 0.00;
                var price4 = 0.00;
                var price5 = 0.00;
                if (($(this).closest("tr").find("input[id*=txtFistAdd3]").val() == "0") || ($(this).closest("tr").find("input[id*=txtFistAdd3]").val().charAt(0) == "0")) {
                    $(this).closest("tr").find("input[id*=txtFistAdd3]").val('1');
                    if ($(this).closest("tr").find("input[id*=txtFistAdd3]").val() == "") {
                        $(this).closest("tr").find("input[id*=txtFistAdd3]").val(' ');
                    }
                    total = 0;
                    var q = parseFloat($(this).val());
                    if (isNaN(q)) q = 0;
                    if (($(this).closest("tr").find("input[id*=txtFirst]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFirst]").val() != "") && ($(this).closest("tr").find("input[id*=txtFirst]").val().charAt(0) != "0")) {
                        price1 = parseFloat($(this).closest("tr").find("input[id*=txtFirst]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val().charAt(0) != "0")) {
                        price2 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd1]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val().charAt(0) != "0")) {
                        price3 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd2]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val().charAt(0) != "0")) {
                        price4 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd4]").val());
                    }

                    if (total == "0") {
                        $(this).closest("tr").find("input[id*=txtTotal2]").val("");
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txtTotal2]").val(q + price1 + price2 + price3 + price4);
                    }
                    if (($(this).closest("tr").find("input[id*=txtSecond]").val() != "0") && ($(this).closest("tr").find("input[id*=txtSecond]").val() != "") && ($(this).closest("tr").find("input[id*=txtSecond]").val().charAt(0) != "0")) {
                        price5 = parseFloat($(this).closest("tr").find("input[id*=txtSecond]").val());
                    }

                    var final = parseFloat(total + price5);
                    if (final == "0") {
                        $(this).closest("tr").find("input[id*=txtFinal]").val(total);
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txtFinal]").val(final);
                    }
                    $("input[id*=txtTotal2]").each(function (index, item) {
                        tempAmount = parseFloat($(item).val());
                        if (isNaN(tempAmount)) tempAmount = 0;
                        total = total + tempAmount;
                    });
                }

                total = 0.00;
                var q = parseFloat($(this).val());
                if (isNaN(q)) q = 0;
                if (($(this).closest("tr").find("input[id*=txtFirst]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFirst]").val() != "") && ($(this).closest("tr").find("input[id*=txtFirst]").val().charAt(0) != "0")) {
                    price1 = parseFloat($(this).closest("tr").find("input[id*=txtFirst]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val().charAt(0) != "0")) {
                    price2 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd1]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val().charAt(0) != "0")) {
                    price3 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd2]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd4]").val().charAt(0) != "0")) {
                    price4 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd4]").val());
                }

                var total = parseFloat(q + price1 + price2 + price3 + price4);
                if (total == "0") {
                    $(this).closest("tr").find("input[id*=txtTotal2]").val("");
                }
                else {
                    $(this).closest("tr").find("input[id*=txtTotal2]").val(q + price1 + price2 + price3 + price4);
                }
                if (($(this).closest("tr").find("input[id*=txtSecond]").val() != "0") && ($(this).closest("tr").find("input[id*=txtSecond]").val() != "") && ($(this).closest("tr").find("input[id*=txtSecond]").val().charAt(0) != "0")) {
                    price5 = parseFloat($(this).closest("tr").find("input[id*=txtSecond]").val());
                }

                var final = parseFloat(total + price5);
                if (final == "0") {
                    $(this).closest("tr").find("input[id*=txtFinal]").val(total);
                }
                else {
                    $(this).closest("tr").find("input[id*=txtFinal]").val(final);
                }
                $("input[id*=txtTotal2]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    total = total + tempAmount;

                });
                total = total.toFixed(2);
            });

            $("table[id*=grdDetail] input[type=text][id*=txtFistAdd4]").blur(function () {
                var price1 = 0.00;
                var price2 = 0.00;
                var price3 = 0.00;
                var price4 = 0.00;
                var price5 = 0.00;
                if (($(this).closest("tr").find("input[id*=txtFistAdd4]").val() == "0") || ($(this).closest("tr").find("input[id*=txtFistAdd4]").val().charAt(0) == "0")) {
                    $(this).closest("tr").find("input[id*=txtFistAdd4]").val('1');
                    if ($(this).closest("tr").find("input[id*=txtFistAdd4]").val() == "") {
                        $(this).closest("tr").find("input[id*=txtFistAdd4]").val(' ');
                    }
                    total = 0;
                    var q = parseFloat($(this).val());
                    if (isNaN(q)) q = 0;
                    alert(q);
                    if (($(this).closest("tr").find("input[id*=txtFirst]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFirst]").val() != "") && ($(this).closest("tr").find("input[id*=txtFirst]").val().charAt(0) != "0")) {
                        price1 = parseFloat($(this).closest("tr").find("input[id*=txtFirst]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val().charAt(0) != "0")) {
                        price2 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd1]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val().charAt(0) != "0")) {
                        price3 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd2]").val());
                    }
                    if (($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val().charAt(0) != "0")) {
                        price4 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd3]").val());
                    }

                    if (total == "0") {
                        $(this).closest("tr").find("input[id*=txtTotal2]").val("");
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txtTotal2]").val(q + price1 + price2 + price3 + price4);
                    }
                    if (($(this).closest("tr").find("input[id*=txtSecond]").val() != "0") && ($(this).closest("tr").find("input[id*=txtSecond]").val() != "") && ($(this).closest("tr").find("input[id*=txtSecond]").val().charAt(0) != "0")) {
                        price5 = parseFloat($(this).closest("tr").find("input[id*=txtSecond]").val());
                    }

                    var final = parseFloat(total + price5);
                    if (final == "0") {
                        $(this).closest("tr").find("input[id*=txtFinal]").val(total);
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txtFinal]").val(final);
                    }
                    $("input[id*=txtTotal2]").each(function (index, item) {
                        tempAmount = parseFloat($(item).val());
                        if (isNaN(tempAmount)) tempAmount = 0;
                        total = total + tempAmount;
                    });
                }

                total = 0.00;
                var q = parseFloat($(this).val());
                if (isNaN(q)) q = 0;
                if (($(this).closest("tr").find("input[id*=txtFirst]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFirst]").val() != "") && ($(this).closest("tr").find("input[id*=txtFirst]").val().charAt(0) != "0")) {
                    price1 = parseFloat($(this).closest("tr").find("input[id*=txtFirst]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd1]").val().charAt(0) != "0")) {
                    price2 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd1]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd2]").val().charAt(0) != "0")) {
                    price3 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd2]").val());
                }
                if (($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "0") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val() != "") && ($(this).closest("tr").find("input[id*=txtFistAdd3]").val().charAt(0) != "0")) {
                    price4 = parseFloat($(this).closest("tr").find("input[id*=txtFistAdd3]").val());
                }

                var total = parseFloat(q + price1 + price2 + price3 + price4);
                if (total == "0") {
                    $(this).closest("tr").find("input[id*=txtTotal2]").val("");
                }
                else {
                    $(this).closest("tr").find("input[id*=txtTotal2]").val(q + price1 + price2 + price3 + price4);
                }
                if (($(this).closest("tr").find("input[id*=txtSecond]").val() != "0") && ($(this).closest("tr").find("input[id*=txtSecond]").val() != "") && ($(this).closest("tr").find("input[id*=txtSecond]").val().charAt(0) != "0")) {
                    price5 = parseFloat($(this).closest("tr").find("input[id*=txtSecond]").val());
                }

                var final = parseFloat(total + price5);
                if (final == "0") {
                    $(this).closest("tr").find("input[id*=txtFinal]").val(total);
                }
                else {
                    $(this).closest("tr").find("input[id*=txtFinal]").val(final);
                }
                $("input[id*=txtTotal2]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    total = total + tempAmount;

                });
                total = total.toFixed(2);
            });
            $("table[id*=grdDetail] input[type=text][id*=txtSecond]").blur(function () {
                var price1 = 0.00;
                if (($(this).closest("tr").find("input[id*=txtSecond]").val() == "0") || ($(this).closest("tr").find("input[id*=txtSecond]").val().charAt(0) == "0")) {
                    $(this).closest("tr").find("input[id*=txtSecond]").val('1');
                    if ($(this).closest("tr").find("input[id*=txtSecond]").val() == "") {
                        $(this).closest("tr").find("input[id*=txtSecond]").val(' ');
                    }
                    total = 0;
                    var q = parseFloat($(this).val());
                    if (isNaN(q)) q = 0;
                    if (($(this).closest("tr").find("input[id*=txtTotal2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtTotal2]").val() != "") && ($(this).closest("tr").find("input[id*=txtTotal2]").val().charAt(0) != "0")) {
                        price1 = parseFloat($(this).closest("tr").find("input[id*=txtTotal2]").val());
                    }
                    var final = parseFloat(total + price1);
                    if (final == "0") {
                        $(this).closest("tr").find("input[id*=txtFinal]").val(price1);
                    }
                    else {
                        $(this).closest("tr").find("input[id*=txtFinal]").val(final);
                    }
                    $("input[id*=txtFinal]").each(function (index, item) {
                        tempAmount = parseFloat($(item).val());
                        if (isNaN(tempAmount)) tempAmount = 0;
                        total = total + tempAmount;
                    });
                }

                total = 0.00;
                var q = parseFloat($(this).val());
                if (isNaN(q)) q = 0;
                if (($(this).closest("tr").find("input[id*=txtTotal2]").val() != "0") && ($(this).closest("tr").find("input[id*=txtTotal2]").val() != "") && ($(this).closest("tr").find("input[id*=txtTotal2]").val().charAt(0) != "0")) {
                    price1 = parseFloat($(this).closest("tr").find("input[id*=txtTotal2]").val());
                }
                var final = parseFloat(price1 + q);
                if (final == "0") {
                    $(this).closest("tr").find("input[id*=txtFinal]").val(price1);
                }
                else {
                    $(this).closest("tr").find("input[id*=txtFinal]").val(final);
                }
                $("input[id*=txtFinal]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    total = total + tempAmount;
                });
                total = total.toFixed(2);
            });


            $("#grdDetail tr").each(function () {
                var checkBox = $(this).find("input[type='checkbox']");
                if ($(checkBox).is(':checked')) {
                    $(this).attr("checked", "checked");
                    var td = $("td", $(this).closest("tr"));
                    $("input[type=text]", td).removeAttr("disabled");
                } else {
                    $(this).removeAttr("checked");
                    var td = $("td", $(this).closest("tr"));
                    $("input[type=text]", td).attr("disabled", "disabled");
                }

            });

            $('#<%=grdDetail.ClientID %>').find('input:checkbox[id$="chkAll"]').click(function () {
                var isChecked = $(this).prop("checked");
                $("#<%=grdDetail.ClientID %> [id*=chkSelect]:checkbox").prop('checked', isChecked);
            });


            $("[id*=chk]").live("click", function () {
                var grid = $(this).closest("table");
                var chkHeader = $("[id*=chkAll]", grid);
                if (!$(this).is(":checked")) {
                    var td = $("td", $(this).closest("tr"));
                    td.css({ "background-color": "FFF" });
                    chkHeader.removeAttr("checked");
                    $("input[type=text]", td).attr("disabled", "disabled");
                } else {
                    var td = $("td", $(this).closest("tr"));
                    td.css({ "background-color": "A1DCF2" });
                    $("input[type=text]", td).removeAttr("disabled");
                    if ($("[id*=chk]", grid).length == $("[id*=chk]:checked", grid).length)
                        chkHeader.attr("checked", "checked");
                }

            });
            function checkAll(objRef) {
                var GridView = objRef.parentNode.parentNode.parentNode;
                var inputList = GridView.getElementsByTagName("input");
                for (var i = 0; i < inputList.length; i++) {
                    var row = inputList[i].parentNode.parentNode;
                    if (inputList[i].type == "checkbox" && objRef != inputList[i]) {
                        if (objRef.checked) {
                            inputList[i].checked = true;
                        }
                        else {
                            inputList[i].checked = false;
                        }
                    }
                }
            }
        });

    </script>
    <script type="text/javascript">
        function Check_Click(objRef) {
            var row = objRef.parentNode.parentNode;
            var GridView = row.parentNode;
            var inputList = GridView.getElementsByTagName("input");
            for (var i = 0; i < inputList.length; i++) {
                var headerCheckBox = inputList[0];
                var checked = true;
                if (inputList[i].type == "checkbox" && inputList[i] != headerCheckBox) {
                    if (!inputList[i].checked) {
                        checked = false;
                        break;
                    }
                }
            }
            headerCheckBox.checked = checked;
        }
    </script>



</asp:Content>
