<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="TTDApproval.aspx.cs" Inherits="Design_BloodBank_TTDApproval" EnableEventValidation="false" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="../../Scripts/Message.js" type="text/javascript" ></script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                // if the key pressed is the escape key, dismiss the dialog
                $find('mpeCreateGroup').hide();
            }
        }

    </script>
    <script type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#txtcollectfrom').change(function () {
                ChkDate();
            });
            $('#txtcollectTo').change(function () {
                ChkDate();
            });

            $(".status").mouseover(function () {
                this.parentNode.parentNode.style.backgroundColor = 'cyan';
            });
            $(".status").mouseout(function () {

                this.parentNode.parentNode.style.backgroundColor = 'transparent';
            });
            $(".history").mouseover(function () {

                this.parentNode.parentNode.style.backgroundColor = '#C2D69B';
            });
            $(".history").mouseout(function () {

                this.parentNode.parentNode.style.backgroundColor = 'transparent';
            });
        });



        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtcollectfrom').val() + '",DateTo:"' + $('#txtcollectTo').val() + '"}',                type: "POST",                dataType: "json",                contentType: "application/json; charset=utf-8",                success: function (mydata) {
                    var data = mydata.d;                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');                        $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');
                        $('#<%=grdDonor.ClientID %>').hide();
                    }                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');
                    }
                }
            });
        }

        $(document).ready(function () {
            $("#ctl00_ContentPlaceHolder1_grvListForm_ctl01_chkAll").click(function () {
                if ($(this).attr("checked"))
                    $("#<%=grvListForm.ClientID %> tr").attr("style", "background-color:aqua");
                $(".radio").each(function () {
                    $(this).find(":radio").attr({ checked: true });
                    // $(this).find(":radio").closest("td").attr("style","background-color:aqua");

                });
            });
            $("#ctl00_ContentPlaceHolder1_grvListForm_ctl01_chkAll1").click(function () {
                if ($(this).attr("checked"))
                    $("#<%=grvListForm.ClientID %> tr").attr("style", "background-color:#C2D69B");
                $(".radio1").each(function () {
                    $(this).find(":radio").attr({ checked: true });
                });
            });

            $(".radio1").click(function () {

                $(this).closest('tr').attr("style", "background-color:#C2D69B");
            });

            $(".radio").click(function () {

                $(this).closest('tr').attr("style", "background-color:aqua");
            });

        });
        var oldgridcolor;
        function SetMouseOver(element) {
            oldgridcolor = element.style.backgroundColor;
            element.style.backgroundColor = '#C2D69B';
            element.style.cursor = 'pointer';
            element.style.textDecoration = 'underline';
        }
        function SetMouseOut(element) {
            element.style.backgroundColor = oldgridcolor;
            element.style.textDecoration = 'none';

        }
        function CheckApprove_Click(objRef) {

            var row = objRef.parentNode.parentNode;
            if (objRef.checked) {
                row.style.backgroundColor = "aqua";
            }
            else {
                if (row.rowIndex % 2 == 0) {
                    row.style.backgroundColor = "#C2D69B";
                }
                else {
                    row.style.backgroundColor = "white";
                }
            }
        }
        function CheckRetest_Click(objRef) {

            var row = objRef.parentNode.parentNode;
            if (objRef.checked) {
                row.style.backgroundColor = "#C2D69B";
            }
            else {
                if (row.rowIndex % 2 == 0) {
                    row.style.backgroundColor = "aqua";
                }
                else {
                    row.style.backgroundColor = "white";
                }
            }
        }
    </script>
    <script type="text/javascript">
        function checkAll(objRef) {

            var GridView = objRef.parentNode.parentNode.parentNode;
            var inputList = GridView.getElementsByTagName("input");
            for (var i = 0; i < inputList.length; i++) {
                var row = inputList[i].parentNode.parentNode;
                if (inputList[i].type == "radio" && objRef != inputList[i]) {
                    if (objRef.checked) {

                        row.style.backgroundColor = "aqua";
                        inputList[i].checked = true;
                    }
                    else {

                        if (row.rowIndex % 2 == 0) {
                            row.style.backgroundColor = "#C2D69B";
                        }
                        else {
                            row.style.backgroundColor = "white";
                        }
                        inputList[i].checked = false;
                    }
                }
            }
        }
    </script>
    <script type="text/javascript">
        function RestrictDoubleEntry(btn) {

            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
        }

        function RestrictDoubleEntry1(btn) {

            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnRepeate', '');
        }
    </script>

    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>TTD Testing Approval</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Blood Collection Id
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCollectionId" runat="server" MaxLength="20" TabIndex="1"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Donor ID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDonorId" runat="server" MaxLength="20" TabIndex="2"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Donor Name 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtName" runat="server" MaxLength="50" TabIndex="3"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Blood Group
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlBloodgroup" runat="server"
                                TabIndex="4">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Collect From 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtcollectfrom" runat="server" ClientIDMode="Static" TabIndex="5"></asp:TextBox>
                            <cc1:CalendarExtender ID="calcollectfrom"
                                TargetControlID="txtcollectfrom" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Collect To
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtcollectTo" runat="server" ClientIDMode="Static" TabIndex="6"></asp:TextBox>
                            <cc1:CalendarExtender ID="calcollectTo"
                                TargetControlID="txtcollectTo" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Label ID="lblSessionCenter" runat="server" Visible="false"></asp:Label>
            <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search"
                OnClick="btnSearch_Click" ValidationGroup="a" TabIndex="7" />&nbsp;
            <asp:Label ID="lblScreeningId" runat="server" Visible="false"></asp:Label>
            <asp:Label ID="lblDonationId" runat="server" Visible="false"></asp:Label>
        </div>
        <asp:Panel ID="pnlHide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:GridView ID="grdDonor" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle"
                    OnRowCommand="grdDonor_RowCommand">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Donor ID" HeaderStyle-Width="130px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblDonorID" runat="server" Text='<%# Eval("Visitor_ID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Collection ID" HeaderStyle-Width="120px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblScreeningId" runat="server" Text='<%# Eval("Screening_Id") %>'
                                    Visible="false"></asp:Label>
                                <asp:Label ID="lblDonationID" runat="server" Text='<%# Eval("BloodCollection_ID") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Tube No." HeaderStyle-Width="130px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblTubeNo" runat="server" Text='<%# Eval("BBTubeNo") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name" HeaderStyle-Width="200px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblName" runat="server" Text='<%# Eval("Name") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="BloodGroup" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblGroup" runat="server" Text='<%# Eval("BloodGroup") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblDonationDate" runat="server" Text='<%#Eval("collecteddate")%>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status" HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgResult" runat="server" ImageUrl="../../Images/view.gif"
                                    class="status" CommandName="AResult" CommandArgument='<%# Container.DataItemIndex %>' CausesValidation="false" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="History" HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgHistory" runat="server" ImageUrl="../../Images/Post.gif"
                                    class="history" CommandName="AHistory" CommandArgument='<%# Eval("BloodCollection_ID") %>' CausesValidation="false" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlHide1" runat="server" Visible="false" Width="300px">
            <div class="POuter_Box_Inventory">
                <div id="dvHistory" runat="server" class="content" style="text-align: center;">
                    <asp:GridView ID="grdHistory" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle"
                        OnRowDataBound="grdHistory_RowDataBound">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="Date" HeaderStyle-Width="130px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("Date")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Time" HeaderStyle-Width="130px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("Time")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Screening ID" HeaderStyle-Width="120px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("Screening_Id")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Test Name" HeaderStyle-Width="130px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("TestName")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Value" HeaderStyle-Width="200px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("Value") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Method" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("Method")%>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Result" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("Result")%>
                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlComponent" runat="server" Visible="false">
            <div class="POuter_Box_Inventory">
                <div class="content" style="text-align: center;">
                    <asp:GridView ID="grvListForm" runat="server" AutoGenerateColumns="False"
                        CssClass="GridViewStyle" OnRowDataBound="grvListForm_RowDataBound">
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Test">
                                <ItemTemplate>
                                    <asp:Label ID="lblGrdScreeningId" Text='<%# Eval("id") %>' Visible="false" runat="server">
                                    </asp:Label>
                                    <asp:Label ID="lblBloodCollection_ID" Text='<%# Eval("BloodCollection_ID") %>' Visible="false"
                                        runat="server">
                                    </asp:Label>
                                    <%# Eval("TestName")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Value">
                                <ItemTemplate>
                                    <asp:Label ID="lblValue" runat="server" Text='<%# Eval("Value") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Method">
                                <ItemTemplate>
                                    <asp:Label ID="lblMethod" runat="server" Text='<%# Eval("Method") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Result">
                                <ItemTemplate>
                                    <asp:Label ID="lblResult" runat="server" Text='<%# Eval("Result") %>'></asp:Label>
                                    <asp:Label ID="lblResultID" runat="server" Text='<%# Eval("ResultID") %>' Visible="false"></asp:Label>

                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Result1">
                                <ItemTemplate>
                                    <asp:Label ID="lblResult1" runat="server" Text='<%# Eval("Result1") %>'></asp:Label>
                                    <asp:Label ID="lblResultID1" runat="server" Text='<%# Eval("ResultID1") %>' Visible="false"></asp:Label>

                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Result2">
                                <ItemTemplate>
                                    <asp:Label ID="lblResult2" runat="server" Text='<%# Eval("Result2") %>'></asp:Label>
                                    <asp:Label ID="lblResultID2" runat="server" Text='<%# Eval("ResultID2") %>' Visible="false"></asp:Label>

                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Approve" Visible="false">
                                <ItemTemplate>
                                    <asp:RadioButton ID="rdbApprove" runat="server" Checked="true" />
                                </ItemTemplate>

                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Retest" Visible="false">
                                <ItemTemplate>
                                    <asp:RadioButton ID="rdbRetest" runat="server" />
                                </ItemTemplate>

                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>

                        </Columns>
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    </asp:GridView>
                    <div style="text-align: right;">
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <asp:Button ID="btnSave" Text="Post" AccessKey="W" CssClass="ItDoseButton"
                    runat="server" ValidationGroup="save" OnClick="btnSave_Click" OnClientClick="return RestrictDoubleEntry(this);" />
                <asp:Button ID="btnRepeate" Text="Repeat" CssClass="ItDoseButton"
                    runat="server" OnClick="btnRepeate_Click" Visible="false" OnClientClick="return RestrictDoubleEntry1(this);" />
                <asp:Button ID="btnReject" Text="Discard" CssClass="ItDoseButton" runat="server"
                    OnClientClick="return confirm('Are you Sure to Discard All ?');" OnClick="btnReject_Click" />

            </div>
        </asp:Panel>
        <div style="display: none;">
            <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton" />
        </div>
        <asp:Panel ID="pnlUpdate" runat="server" CssClass="pnlItemsFilter" Width="390px" Style="display: none">

            <div class="Purchaseheader" id="dragUpdate" runat="server" style="width: 378px;">
                Reason Of Reject :
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;
                            Press esc to close
                    
            </div>
            <div style="text-align: center">
                Reason :&nbsp;<asp:TextBox ID="txtReason" runat="server" Width="260px" MaxLength="100"></asp:TextBox>
                <asp:RequiredFieldValidator ID="reqReason" runat="server" ControlToValidate="txtReason"
                    ErrorMessage="*" ValidationGroup="btnsave"></asp:RequiredFieldValidator>
            </div>
            <div class="filterOpDiv" style="text-align: center;">
                <asp:Button ID="btnFinalReject" Text="Save" CssClass="ItDoseButton" runat="server"
                    OnClick="btnFinalReject_Click" ValidationGroup="btnsave" />&nbsp;&nbsp;&nbsp;
                    <asp:Button ID="btnCancel" Text="Cancel" CssClass="ItDoseButton" runat="server"
                        CausesValidation="False" />&nbsp;
            </div>

        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpeCreateGroup" runat="server" CancelControlID="btnCancel"
            DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlUpdate" PopupDragHandleControlID="pnlUpdate" BehaviorID="mpeCreateGroup">
        </cc1:ModalPopupExtender>

    </div>
</asp:Content>
