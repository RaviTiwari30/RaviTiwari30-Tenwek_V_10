<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="SchedulerMaster.aspx.cs" Inherits="Design_EDP_SchedulerMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
  <%--  <script type="text/javascript" src="../../Scripts/jquery-1.4.2.min.js"></script>--%>
    <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
    <div id="Pbody_box_inventory">
        <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Scheduler Master</b><br />
            <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Scheduler Details
            </div>
            <table style="width: 100%; border-collapse: collapse">
                <tr>

                    <td style="text-align: right">Panel Group :&nbsp;
                    </td>
                    <td style="text-align: left">
                        <asp:CheckBoxList ID="chklPanelGroup" RepeatLayout="Table" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static" RepeatColumns="9">
                        </asp:CheckBoxList>
                    </td>
                </tr>
                <tr >
                    <td style="text-align: right">Services :&nbsp;
                    </td>
                    <td style="text-align: left">
                        <table style="width: 100%" >
                            <tr>
                                <td style="width: 30%; text-align: right">
                                    <asp:CheckBoxList ID="chklServices" RepeatLayout="Table" onclick="chkServices()" runat="server" ClientIDMode="Static" RepeatDirection="Horizontal">
                                        <asp:ListItem Value="1" Text="Category" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Items"></asp:ListItem>
                                    </asp:CheckBoxList>
                                </td>
                                <td style="width: 30%; text-align: left">
                                    <asp:TextBox ID="txtItem" runat="server" ClientIDMode="Static" Width="280px"></asp:TextBox>
                                </td>
                                <td style="width: 40%; text-align: left">
                                    <asp:Button ID="btnAdd" runat="server" ClientIDMode="Static" Text="Add" CssClass="ItDoseButton" OnClick="btnAdd_Click" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>

            </table>

        </div>
        <div class="POuter_Box_Inventory">
            <asp:GridView ID="grdSc" ClientIDMode="Static" runat="server" BorderStyle="Solid" OnRowCreated="grdSc_RowCreated" CssClass="GridViewStyle" BorderWidth="1px" CellPadding="4" OnRowDataBound="grdSc_RowDataBound">
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:CheckBox ID="chk" runat="server" onclick="chkAll(this)" CssClass="chkClass" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Label ID="lblName" runat="server" Text='<%#Eval("Name") %>'></asp:Label>
                            <asp:Label ID="lblID" runat="server" Text='<%#Eval("ID") %>' Visible="false"></asp:Label>
                            <asp:Label ID="lblIsConfig" runat="server" Text='<%#Eval("IsConfig") %>' Visible="false"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>
            </asp:GridView>
            <table style="width: 100%; text-align: center">
                <tr>
                    <td style="text-align: right; width: 22%">Run Scheduler :&nbsp;
                    </td>
                    <td style="text-align: left; width: 40%">

                        <asp:RadioButtonList ID="rblRunSche" onclick="chkSch()" runat="server" ClientIDMode="Static" RepeatDirection="Horizontal">
                           <%-- <asp:ListItem Value="1" Text="ON Room Check-In Time" Selected="false"></asp:ListItem>--%>
                            <asp:ListItem Value="2" Text="ON Specefic Time" Selected="True"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td style="text-align: left; width: 48%">
                        <asp:TextBox ID="txtSpecificTime" CssClass="SpecificTime" runat="server" ClientIDMode="Static" Width="80px" Style="display: none"></asp:TextBox>
                        <em class="SpecificTime"><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                        <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
                            TargetControlID="txtSpecificTime" AcceptAMPM="True">
                        </cc1:MaskedEditExtender>
                        <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtSpecificTime"
                            ControlExtender="masTime" IsValidEmpty="true" EmptyValueMessage="Time Required"
                            InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                    </td>
                    <%--  </tr>

                         </table>
                    </td>--%>
                </tr>

            </table>
            <table style="width: 100%; text-align: center">
                <tr>
                    <td colspan="2">
                        <table style="width: 100%">
                            <tr id="trRoomRate">
                                <td style="text-align: right; width: 50%">Difference in Hours From Previous Applied Room Rate :&nbsp;
                                </td>
                                <td style="text-align: left; width: 50%">
                                    <asp:TextBox ID="txtRateHr" runat="server" Width="60px" MaxLength="2" ClientIDMode="Static"></asp:TextBox>Hr
                    <asp:TextBox ID="txtRateMin" runat="server" Width="60px" MaxLength="2" ClientIDMode="Static"></asp:TextBox>Min
                   <%-- <cc1:NumericUpDownExtender ID="nuRateHr"   Width="80" runat="server" Maximum="24" Minimum="00" TargetControlID="txtRateHr"></cc1:NumericUpDownExtender>
                    <cc1:NumericUpDownExtender ID="nuRateMin" Width="80" runat="server" Maximum="60" Minimum="00" TargetControlID="txtRateMin"></cc1:NumericUpDownExtender>--%>
                                    <cc1:FilteredTextBoxExtender ID="ftbHr" runat="server" TargetControlID="txtRateHr" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                                    <cc1:FilteredTextBoxExtender ID="ftbMin" runat="server" TargetControlID="txtRateMin" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                                    <%-- <asp:RangeValidator ID="ranHr"  runat="server" ControlToValidate="txtRateHr" MinimumValue="0" MaximumValue="24"></asp:RangeValidator>--%>
                                </td>
                            </tr>


                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSave" runat="server" OnClientClick="return validate()" Text="Save" CssClass="ItDoseButton" OnClick="btnSave_Click" />
        </div>
    </div>
    <script type="text/javascript">
        function validate() {
            if ($("#chklPanelGroup input[type=checkbox]:checked").length == "0") {
                $("#lblMsg").text('Please Select PanelGroup');
                $("#chklPanelGroup").focus();
                return false;
            }
            if (($("#rblRunSche input[type=radio]:checked").val() == "1")) {
                if (($.trim($("#txtRateHr").val()) == "")) {
                    $("#lblMsg").text('Please Enter Room Rate Hours');
                    $("#txtRateHr").focus();
                    return false;
                }
                if (parseFloat($.trim($("#txtRateHr").val())) > 24) {
                    $("#lblMsg").text('Please Enter Valid Rate Hours');
                    $("#txtRateHr").focus();
                    return false;
                }
                if (($("#txtRateMin").val() == "")) {
                    $("#lblMsg").text('Please Enter Room Rate Minutes');
                    $("#txtRateMin").focus();
                    return false;
                }
                if (parseFloat($.trim($("#txtRateMin").val())) > 60) {
                    $("#lblMsg").text('Please Enter Valid Rate Minutes');
                    $("#txtRateMin").focus();
                    return false;
                }
            }
            else if (($("#rblRunSche input[type=radio]:checked").val() == "2")) {
                if (($("#txtSpecificTime").val() == "")) {
                    $("#lblMsg").text('Please Enter SpecificTime');
                    $("#txtSpecificTime").focus();
                    return false;
                }

            }
            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
        }
        function chkSch() {
            var value = $("#rblRunSche input[type=radio]:checked").val();
            if (value == "1") {
                $(".SpecificTime").val('').hide();
                $("#trRoomRate").val('').show();
            }
            else {
                $(".SpecificTime").val('').show();
                $("#trRoomRate").val('').hide();
            }
        }
    </script>

    <script type="text/javascript">
        function chkAll(rowID) {
            // $("#grdSc input:checkbox").attr("checked",function()

            if ($("#grdSc input:checkbox[name$='chk']").is(":checked"))
                $(rowID).closest('tr').find('input[type=checkbox]').attr('checked', 'checked');
            else
                $(rowID).closest('tr').find('input[type=checkbox]').attr('checked', false);
        }
        $(function () {
            chkSch();
            chkServices();
        });
        function chkServices() {
            var selectedValues = [];
            $("[id*=chklServices] input:checked").each(function () {
                selectedValues.push($(this).val());

            });
            if (selectedValues.length > 0) {

            }

        }
    </script>
    <cc1:AutoCompleteExtender runat="server" ID="autoComplete1" TargetControlID="txtItem"
        FirstRowSelected="true" BehaviorID="AutoCompleteEx" ServicePath="~/Design/EDP/SchedulerMaster.aspx"
        ServiceMethod="getOtherItems" MinimumPrefixLength="1" EnableCaching="true"
        CompletionSetCount="20" CompletionInterval="1000" CompletionListCssClass="autocomplete_completionListElement"
        CompletionListItemCssClass="autocomplete_listItem" ShowOnlyCurrentWordInCompletionListItem="true"
        CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem">
        <Animations>
         
                    <OnShow>
                        <Sequence>
                            <%-- Make the completion list transparent and then show it --%>
                            <OpacityAction Opacity="0" />
                            <HideAction Visible="true" />
                            
                            <%--Cache the original size of the completion list the first time
                                the animation is played and then set it to zero --%>
                            <ScriptAction Script="
                                // Cache the size and setup the initial size
                                var behavior = $find('AutoCompleteEx');
                                if (!behavior._height) {
                                    var target = behavior.get_completionList();
                                    behavior._height = target.offsetHeight - 2;
                                    target.style.height = '0px';
                                }" />
                            
                            <%-- Expand from 0px to the appropriate size while fading in --%>
                            <Parallel Duration=".4">
                                <FadeIn />
                                <Length PropertyKey="height" StartValue="0" EndValueScript="$find('AutoCompleteEx')._height" />
                            </Parallel>
                        </Sequence>
                    </OnShow>
                    <OnHide>
                        <%-- Collapse down to 0px and fade out --%>
                        <Parallel Duration=".4">
                            <FadeOut />
                            <Length PropertyKey="height" StartValueScript="$find('AutoCompleteEx')._height" EndValue="0" />
                        </Parallel>
                    </OnHide>
        </Animations>
    </cc1:AutoCompleteExtender>
</asp:Content>

