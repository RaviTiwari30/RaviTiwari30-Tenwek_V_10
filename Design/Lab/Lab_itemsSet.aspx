
<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Lab_itemsSet.aspx.cs" Inherits="Design_Lab_Lab_itemsSet" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral,
 PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery.blockUI.js"></script>
    <script type="text/javascript" src="../../Scripts/Search.js"></script>   
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        var keys = [];
        var values = [];
        $(document).ready(function () {
            var options = $('#<% = lstitems.ClientID %> option');
            $.each(options, function (index, item) {
                keys.push(item.value);
                values.push(item.innerHTML);
            });

            $('#<% = txtSearch.ClientID %>').keyup(function (e) {
                searchByFirstChar(document.getElementById('<%=txtSearch.ClientID%>'), document.getElementById('<%=txtcpt.ClientID%>'), document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=lstitems.ClientID%>'), document.getElementById('btnAdd'), values, keys, e)
            });
            $('#<%=txtcpt.ClientID %>').keyup(function (e) {
                searchByCPTCode(document.getElementById('<%=txtSearch.ClientID%>'), document.getElementById('<%=txtcpt.ClientID%>'), document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=lstitems.ClientID%>'), document.getElementById('btnAdd'), values, keys, e)
            });
            $('#<%=txtInBetweenSearch.ClientID %>').keyup(function (e) {
                searchByInBetween(document.getElementById('<%=txtSearch.ClientID%>'), document.getElementById('<%=txtcpt.ClientID%>'), document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=lstitems.ClientID%>'), document.getElementById('btnAdd'), values, keys, e)
            });
        });
        function AddInvestigation(sender, evt) {
            if (evt.keyCode > 0) {
                keyCode = evt.keyCode;
            }
            else if (typeof (evt.charCode) != "undefined") {
                keyCode = evt.charCode;
            }
            if (keyCode == 13) {
                document.getElementById('btnAdd').click();
                evt.preventDefault();
                return false;
            }
         }
        $(document).ready(
               function () {
                   loadSets();
                   $("#<%=ddlSetItem.ClientID %>").change(EditItem);
                   $("#btnSave").attr('style', 'display:none;');
                   $("#btnAdd").click(AddItem);
                   $("#btnSave").click(SaveData);
                   $("#btnCreateSet").click(chkType);
                   var options = $('#<% = lstitems.ClientID %> option');
            });
               
               function wopen(url, name, w, h) {
                   w += 32;
                   h += 96;
                   var win = window.open(url, name, 'width=' + w + ', height=' + h + ', ' + 'location=no, menubar=no, ' + 'status=no, toolbar=no, scrollbars=no, resizable=no');
                   win.resizeTo(w, h);
                   win.moveTo(10, 100);
                   win.focus();
               }
               function loadSets() {
                   $("#<%=ddlSetItem.ClientID %>").empty();
                   var ddlSetItem = $("#<%=ddlSetItem.ClientID%>");
                   var Status = "0,1";
                  jQuery.ajax({
                      url:"Lab_itemsSet.aspx/loadSets",
                      data: '{Status:"'+ Status +'"}',
                      type: "Post",
                      contentType: "application/json; charset=utf-8",
                      timeout: 120000,
                      async: false,
                      dataType: "json",
                      success: function (result) {
                          Data = jQuery.parseJSON(result.d);
                          if (Data != null) {
                              if (Data.length != 0) {
                                  ddlSetItem.append($("<option></option>").val("0").html("Select"));
                                  for (i = 0; i < Data.length; i++) {
                                      ddlSetItem.append($("<option></option>").val(Data[i].SetID).html(Data[i].setName));
                                  }
                              }
                          }
                          else {
                              ddlSetItem.append($("<option></option>").val("0").html("No Set is Available"));
                          }
                      },
                      error: function (xhr, status) {
                          window.status = status + "\r\n" + xhr.responseText;
                      }
                  });
              }
        function SaveSet() {
            if ($.trim($("#txtSetName").val()) != "") {
                var SetName = $("#txtSetName").val();
                var txtDescription = $.trim($("#<%=txtDescription.ClientID %>").val());
                var Status = "0";
                if ($("#rdoActive").is(':checked')) {
                    Status = "1";
                }
                $.ajax({
                    url: "Lab_itemsSet.aspx/SaveSet",
                    data: '{SetName:"' + SetName + '",Description:"' + txtDescription + '",SetID:"' + $('#spnsetid').text() + '", Status:"' + Status + '"}', // parameter map
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: false,
                    dataType: "json",
                    success: function (result) {
                        Data = (result.d);
                        if (Data == "2") {
                            DisplayMsg('MM024', 'spnMsg');
                            loadSets();
                            $("#txtSetName").val(' ');
                            $find('mpe').hide();
                            jQuery("#ddlSetItem option").remove();
                        }
                        else if (Data == "1") {
                            DisplayMsg('MM01', 'spnMsg');
                            loadSets();
                            $("#txtSetName").val(' ');
                            $find('mpe').hide();
                        }
                        else if (Data == "0") {
                            DisplayMsg('MM05', 'spnMsg');
                            $("#txtSetName").val('');
                            $find('mpe').hide();
                            loadSets();
                        }
                        chkType();
                    },
                    error: function (xhr, status) {
                        window.status = status + "\r\n" + xhr.responseText;
                        return false;
                    }
                });
            }
            else {
                $("#spnMsg").text("Please Enter Set Name");
                $("#txtSetName").focus();

            }
        }
        function EditItem() {
            $("#<%=lblmsg.ClientID %>").text('');
            setId = $("#<%=ddlSetItem.ClientID %>  option:selected").val();
            //if (setId != 0)
            //    $("#btnCreateSet").val('Edit Set');
            //else
            //    $("#btnCreateSet").val('Create Set');
            var ItemData = $("#<%=ddlSetItem.ClientID %>  option:selected").val();
            if ($("#<%=ddlSetItem.ClientID %>  option:selected").text().toUpperCase() == "SELECT") {
                $("#<%=lblmsg.ClientID %>").text('Please Select Set Name');
                $(".show").hide();
                $('#btnAdd').attr('style', 'display:none');
                $('#btnSave').attr('style', 'display:none');
                $('#PatientLabSearchOutput').hide();
                return;
            }
            $.blockUI();
            $.ajax({
                url: "Lab_itemsSet.aspx/LoadSetItems",
                data: '{SetID:' + setId + '}',
                type: "POST",
                contentType: "application/json;charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    PatientData = jQuery.parseJSON(result.d);
                    if (PatientData != null) {
                    var output = $('#tb_PatientLabSearch').parseTemplate(PatientData);
                        $('#PatientLabSearchOutput').html(output);
                        $('#PatientLabSearchOutput').show();
                        $('#btnAdd').attr('style', 'display:""');
                        $('#btnSave').attr('style', 'display:none');
                        $(".show").show();
                        $.unblockUI();
                    }
                    else {
                        $('#PatientLabSearchOutput').hide();
                        $('#PatientLabSearchOutput').clearQueue();
                        DisplayMsg('MM253', 'spnMsg');
                        $.unblockUI();
                    }
                    

                },
                error: function (xhr, status) {
                    alert(status + "\r\n" + xhr.responseText);
                    DisplayMsg('MM05', 'spnMsg');
                    $("#btnSave").attr('disabled', false);
                    $.unblockUI();
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });

        }
        
       
        
        function SaveData()
        {
            if ($.trim($("#<%=ddlSetItem.ClientID %> ").val()) != "0") {
                var dataLTDt = new Array();
                var ObjLdgTnxDt = new Object();
                jQuery("#tb_grdLabSearch tr").each(function () {
                    var id = jQuery(this).attr("id");
                    var $rowid = jQuery(this).closest("tr");
                    if (id != "Header") {
                        ObjLdgTnxDt.SetID = jQuery.trim($rowid.find("#td_setId").text());
                        ObjLdgTnxDt.ItemID = jQuery.trim($rowid.find("#td_ItemID").text());
                        ObjLdgTnxDt.Quantity = jQuery.trim($rowid.find("#td_Qty").text());
                        dataLTDt.push(ObjLdgTnxDt);
                        ObjLdgTnxDt = new Object();
                    }
                    
                });
                if (dataLTDt.length > 0) {
                    $.ajax({
                        url: "Lab_itemsSet.aspx/SaveSetItem",
                        data: JSON.stringify({ Data: dataLTDt }),
                        type: "POST", // data has to be Posted    	        
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        async: false,
                        success: function (result) {
                            Data = result.d;
                         
                            if (Data == "1") {
                                $("#tb_grdLabSearch tr:not(:first)").remove();
                                $("#tb_grdLabSearch").hide();
                                DisplayMsg('MM01', 'spnMsg');
                                $("#btnSave").hide();
                                EditItem();
                               
                            }
                            else {
                                $("spnMsg").text('Record Not Saved');
                            }
                            $("#btnSave").attr('disabled', false);
                        },
                        error: function (xhr, status) {
                            alert(status + "\r\n" + xhr.responseText);
                            DisplayMsg('MM05', 'spnMsg');
                            $("#btnSave").attr('disabled', false);
                            window.status = status + "\r\n" + xhr.responseText;
                        }
                    });
                }
            }
        }
        var RowCount;
        var setId;
        function AddItem() {
            if ($("#<%=ddlSetItem.ClientID %> option:selected").val() != '0') {
                var ItemName = $("#<%=lstitems.ClientID %> option:selected").text();
                var ItemID = $("#<%=lstitems.ClientID %> option:selected").val().split('#')[0];
                var Qty = 1;
                if (Qty == "" || Qty == "0") {
                    alert('Please Enter Quantity');
                    $("#<%=txtQty.ClientID %>").focus();
                    if ($("#tb_grdLabSearch tr").length == "1") {
                        $("#btnSave").hide();
                    }
                    else {
                        $("#btnSave").show();
                    }
                    return;
                }
                if ($("#<%=lstitems.ClientID %> option:selected").length == "0") {
                    DisplayMsg('MM018', 'spnMsg');         
                    return;
                }
                RowCount = $("#tb_grdLabSearch tr").length;
                RowCount = RowCount + 1;

                var AlreadySelect = 0;
                if (RowCount > 2) {

                    $("#tb_grdLabSearch tr").each(function () {
                        if ($(this).attr("id") == 'tr_' + ItemID) {
                            AlreadySelect = 1;
                            return;
                        }
                    });
                    if ($("#<%=ddlSetItem.ClientID %>  option:selected").val() != setId) {
                        alert('Set Name Cannot Change');
                        $("#<%=ddlSetItem.ClientID %>").focus();
                        return;
                    }
                }
                setId = $("#<%=ddlSetItem.ClientID %>  option:selected").val();
                var setName = $("#<%=ddlSetItem.ClientID %>  option:selected").text();
                if (setName.toUpperCase() == "SELECT") {
                    DisplayMsg('MM242', 'spnMsg');
                    $("#<%=ddlSetItem.ClientID %>").focus();
                    $("#btnSave").hide();
                    return;
                }
                if (AlreadySelect == "0") {
                    var newRow = $('<tr />').attr('id', 'tr_' + ItemID);
                    newRow.html('<td class="GridViewLabItemStyle" >' + (RowCount - 1) +
                         '</td><td class="GridViewLabItemStyle" style="display:none;" id=td_setId >' + setId +
                         '</td><td class="GridViewLabItemStyle" style="text-align:left" id=td_setName >' + setName +
                         '</td><td  class="GridViewLabItemStyle" style="text-align:left" id=td_ItemName >' + ItemName +
                         '</td><td  class="GridViewLabItemStyle" style="display:none;" id=td_ItemID >' + ItemID +
                         '</td><td  class="GridViewLabItemStyle" style="text-align:center" id=td_Qty >' + Qty +
                         '</td><td class="GridViewLabItemStyle" style="text-align:center"><img id="imgRmv" src="../../Images/Delete.gif" onclick="DeleteRow(this);"  onmouseover="chngcur()" title="Click To Remove" /></td>'
                        );
                    $("#tb_grdLabSearch").append(newRow);
                    $("#tb_grdLabSearch").show();
                    $("#<%=txtQty.ClientID %>").val('');
                    $("#btnSave").show();
                }
                else {
                    DisplayMsg('MM035', 'spnMsg');
                    alert('Item Already Selected');
                }
                $('#<% = txtInBetweenSearch.ClientID %>').val('');
                $('#<% = txtInBetweenSearch.ClientID %>').focus();
            }
            else {
                alert('Please Select the Proper Set');
                $('#<% =ddlSetItem.ClientID %>').focus();
            }
        }
        function DeleteRow(rowid) {
            var row = rowid;
            $(row).closest('tr').remove();
            RowCount = RowCount - 1;
            if ($("#tb_grdLabSearch tr").length == "1") {
                $("#btnSave").hide();
                $("#tb_grdLabSearch").hide();
            }
            else {
                $("#btnSave").show();
            }
        }
        function CheckQtyRecive(RecievedQty) {
            var TDSAmt = $(RecievedQty).val();
            if (TDSAmt.match(/[^0-9]/g)) {
                TDSAmt = TDSAmt.replace(/[^0-9]/g, '');
                $(RecievedQty).val(TDSAmt)
                return;
            }
        }
        document.onkeyup = Esc;
        function Esc() {
            var KeyID = event.keyCode;
            if (KeyID == 27) {
                if ($find("mpe")) {
                    $find("mpe").hide();
                }
            }
        }
        function clearpopup() {
            $("#<%=lblSetError.ClientID %>").text('');
            $("#txtSetName").val('');
            $("#<%=txtDescription.ClientID %>").val('');
        }
        function pageLoad() {
            var modalPopup = $find("mpe");
            if (modalPopup != null) {
                modalPopup.add_shown(OnPopupShow);
            }
        }
        function OnPopupShow() {
            var tb = $get("txtSetName");
            tb.focus();
        }
        function closeSet() {
            $find("mpe").hide();
            clearpopup();
        }
        function bindSet() {
            $("#<%=ddlSetItem.ClientID %> option").remove();
            $.ajax({
                url: "Services/SetMaster.asmx/BindSet",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    SetData = jQuery.parseJSON(result.d);
                    if (SetData.length == 0) {
                        $("#<%=ddlSetItem.ClientID %>").append($("<option></option>").val("0").html("Select"));
                    }
                    else {
                        for (i = 0; i < SetData.length; i++) {
                            $("#<%=ddlSetItem.ClientID %>").append($("<option></option>").val(SetData[i].SetID).html(SetData[i].NAME));
                        }
                    }

                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'spnMsg');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function chngcur() {
            document.body.style.cursor = 'pointer';

        }
        $(function () {
            var MaxLength = 100;
            $("#<% =txtDescription.ClientID %>").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            $("#<% =txtDescription.ClientID %>").bind("keypress", function (e) {
                if (window.event) {
                    keynum = e.keyCode
                }
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                if (e.keyCode == 39 || keychar == "'") {
                    return false;
                }
                if ($(this).val().length >= MaxLength) {
                    if (window.event)//IE
                    {
                        e.returnValue = false;
                        return false;
                    }
                    else//Firefox
                    {
                        e.preventDefault();
                        return false;
                    }

                }
            });
        });
        function validatespace() {
            var Name = $("#txtSetName").val();
            if (Name.charAt(0) == ' ' || Name.charAt(0) == '.' || Name.charAt(0) == ',' || Name.charAt(0) == '0' || Name.charAt(0) == "'" || Name.charAt(0) == '-') {
                $("#txtSetName").val('');
                $('#<%=lblSetError.ClientID %>').text('First Character Cannot Be Space/Dot');
                Name.replace(Name.charAt(0), "");
                return false;
            }
            else {
                $('#<%=lblSetError.ClientID %>').text('');
                return true;
            }
        }
        function check(e) {
            var keynum
            var keychar
            var numcheck
            if (window.event) {
                keynum = e.keyCode
            }
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)

            //List of special characters you want to restrict
            if (keychar == "#" || keychar == "`" || keychar == "!" || keychar == "~" || keychar == ";" || keychar == "/" || (keynum >= "40" && keynum <= "43") || (keynum >= "91" && keynum <= "95") || (keynum >= "58" && keynum <= "64") || (keynum >= "34" && keynum <= "37") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }
            else {
                return true;
            }
        }
        function check1(e) {
            var keynum
            var keychar
            var numcheck
            if (window.event) {
                keynum = e.keyCode
            }
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)
            //List of special characters you want to restrict
            if (keychar == "#" || keychar == "`" || keychar == "!" || keychar == "~" || keychar == ";" || keychar == "/") {
                return false;
            }
            else {
                return true;
            }
        }
    </script>

    <script type="text/javascript" >
        function splcharval(id) {
            id.value = id.value.replace(/[#|\']/g, '');
        }
        //For Search By Word
        function chkType() {
            if ($("#<%=ddlSetItem.ClientID %>").val() != 0) {
                $("#txtSetName").val($("#<%=ddlSetItem.ClientID %> option:selected").text());
                $('#spnsetid').text($("#<%=ddlSetItem.ClientID %>").val());
                $('#btnSaveSet').val("Update");
                $('#trStatus').show();
            }
            else {
                $("#txtSetName").val('');
                $('#spnsetid').text('');
                $('#btnSaveSet').val("Save");
                $('#trStatus').hide();
              //  $("#btnCreateSet").val('Create Set');
            }

        }
    </script>
    <div id="Pbody_box_inventory">
            <cc1:ToolkitScriptManager ID="scripmanger" runat="server">
    </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Investigation Set-Master <br />
            </b>
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError">
            </asp:Label>
             <span id="spnMsg" class="ItDoseLblError"></span><br />
        </div>
        <div class="POuter_Box_Inventory">
               
            <table  style="width: 100%; border-collapse:collapse">
                <tr>
                    <td  style="width: 172px;text-align:right">Set Name :&nbsp;
                    </td>
                    <td colspan="2">
                        <asp:DropDownList ID="ddlSetItem" runat="server" Width="254px" ToolTip="Select Sets">
                        </asp:DropDownList>
                    
                        <asp:Button ID="btnCreateSet" Text="Create Set" CssClass="ItDoseButton" ToolTip="Click To Create New Set" runat="server" ClientIDMode="Static" />
                    </td>
                    <td style="width: 110px;"></td>
                </tr>
                <tr style="display:none">
                    <td  style="width: 172px;text-align:right">Search By Name :&nbsp;
                    </td>
                    <td style="width: 210px">
                        <div>
                             <asp:TextBox ID="txtSearch" runat="server" Width="250px" ClientIDMode="Static" onkeypress="AddInvestigation(this, event);" >
                            </asp:TextBox>
                            
                        </div>
                    </td>
                    <td style="width: 110px"></td>
                    <td style="width: 210px"></td>
                </tr>
                <tr>
                    <td style="width: 172px;text-align:right; height: 22px;">Search By Any Name :&nbsp;</td>
                    <td style="height: 22px">
                        
                        <asp:TextBox ID="txtInBetweenSearch" runat="server" CssClass="ItDoseTextinputText" AutoCompleteType="Disabled"
                                Width="250px" onkeypress="AddInvestigation(this, event);" />
                    </td>
                    <td style="text-align:right; height: 22px;">CPT Code :&nbsp;</td>
                    <td style="height: 22px">
                        <asp:TextBox ID="txtcpt" runat="server" Width="150px" onkeypress="AddInvestigation(this, event);"  />
                    </td>
                </tr>
                <tr>
                    <td style="width: 142px;text-align:right">Item List :&nbsp; </td>
                    <td style="width: 210px;">
                        <div style="padding-top: 2px;">
                            <asp:ListBox ID="lstitems" runat="server" Height="208px" Width="408px" ToolTip="Select Items" onkeypress="AddInvestigation(this, event);"></asp:ListBox>
                        </div>
                    </td>
                    <td style="width: 110px;"></td>
                    <td style="width: 210px;"></td>
                </tr>
                <tr>
                    <td  style="width: 142px;text-align:right">&nbsp;
                    </td>
                    <td style="text-align: left;" colspan="2">
                        <asp:TextBox ID="txtQty" ToolTip="Enter Qty." CssClass="ItDoseTextinputNum" runat="server" MaxLength="3" Width="51px" style="display:none"
                            onkeyup="CheckQtyRecive(this);"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbQty" runat="server" FilterType="Numbers" TargetControlID="txtQty">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td style="width: 142px"></td>
                    <td colspan="2" style="text-align: center">
                        <input id="btnAdd" value="Add" type="button" class="ItDoseButton" title="Click To Add Item" />
                    </td>
                    <td></td>
                </tr>
            </table>
            <table  style="width: 100%; border-collapse:collapse" >
                <tr style="text-align: center">
                    <td colspan="4">
                        <table class="GridViewStyle"    rules="all" border="1" id="tb_grdLabSearch"
                            style="width: 940px;  border-collapse: collapse; display: none;">
                            <tr id="Header">
                                <th class="GridViewHeaderStyle" scope="col" style="width: 40px;">S.No.
                                </th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 140px;">Set Name
                                </th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 320px;">Item Name
                                </th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 90px;">Quantity
                                </th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 70px;">Remove
                                </th>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <table  style="width: 100%; border-collapse:collapse">
                <tr>
                    <td colspan="4" style="text-align: center;">&nbsp;
                    </td>
                </tr>
                <tr>
                    <td colspan="4" style="text-align: center;">
                        <input id="btnSave" value="Save" type="button" class="ItDoseButton" title="Click To Save" />
                    </td>
                </tr>
            </table>
            <table  style="width: 100%; border-collapse:collapse">
                <tr style="text-align:center">
                    <td colspan="4">
                        <div id="PatientLabSearchOutput" style="height:400px;display:none;overflow-y:scroll" >
                        </div>
                       
                    </td>
                   
                </tr>
                <tr style="text-align:center"><td> 
                    <input id="btnitem" value="Update"  style="display:none" type="button" class="ItDoseButton"/>
                                              </td></tr>
            </table>
        </div>
           
        <cc1:ModalPopupExtender ID="mpe" runat="server" PopupControlID="pnlSetMaster" DropShadow="true"
        BackgroundCssClass="filterPupupBackground" BehaviorID="mpe" TargetControlID="btnCreateSet"
        CancelControlID="btnCancel" OnCancelScript="clearpopup()">
    </cc1:ModalPopupExtender>
       
    </div>
   
    <asp:Panel ID="pnlSetMaster" runat="server" style="width: 380px;display:none" CssClass="pnlOrderItemsFilter">
        <div id="Div1" runat="server" class="Purchaseheader">
            <b>Create Set </b>&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;
             &nbsp;&nbsp; &nbsp;  <em ><span style="font-size: 7.5pt"> Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor:pointer"  onclick="closeSet()"/>                               
                                to close</span></em>
        </div>
        <table  style="width: 100%;border-collapse:collapse">
            <tr style="text-align: center;">
                <td colspan="2">
                    <asp:Label ID="lblSetError" runat="server" CssClass="ItDoseLblError"></asp:Label>
                   <span id="spnsetid" style="display:none"></span>
                </td>
            </tr>
            <tr style="text-align: center;">
                <td  style="width: 40px;text-align:right">Set&nbsp;Name :&nbsp;
                </td>
                <td  style="width: 240px;text-align:left">
                    <input id="txtSetName" size="34" maxlength="50" value="" title="Enter Set Name" onkeypress="return check(event)"
                        onkeyup="validatespace();" />
                    <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                </td>
            </tr>
            <tr style="text-align: center;">
                <td  style="width: 40px;text-align:right;vertical-align:top">Description :&nbsp;
                </td>
                <td  style="width: 240px;text-align:left">
                    <asp:TextBox ID="txtDescription" onkeypress="return check1(event)" runat="server"
                        value="" Height="50px" Width="234px" TextMode="MultiLine" ToolTip="Enter Set Description"></asp:TextBox>
                </td>
            </tr>
            <tr id="trStatus" style="display:none">
                <td  style="width: 40px;text-align:right;vertical-align:top">Status :&nbsp;
                </td>
                <td  style="width: 240px;text-align:left">
                        <input id="rdoActive" type="radio" name="Label" value="Active" checked="checked" />Active
             <input id="rdoDeActive" type="radio" name="Label" value="DeActive"  />DeActive 
                </td>
            </tr>
            <tr style="text-align: center;">
                <td colspan="2">
                    <input type="button" id="btnSaveSet" value="Save" class="ItDoseButton" onclick="SaveSet()" />
                    <asp:Button ID="btnCancel" Text="Cancel" ClientIDMode="Static" CssClass="ItDoseButton" runat="server" />
                </td>
            </tr>
        </table>
         
    </asp:Panel>
  
   
     <script id="tb_PatientLabSearch" type="text/html">
    <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="Table1"
    style="width:940px;border-collapse:collapse;">
		<tr id="Tr1">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none;">ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none;">Set ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:160px;">Set Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:65px; display:none">Item ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:380px;">Item Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Quantity</th>
            
            <th class="GridViewHeaderStyle" scope="col"  style="width:45px;">Remove</th>
		</tr>

        <#
       
        var dataLength=PatientData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {

        objRow = PatientData[j];
        
          #>
                    <tr id="<#=objRow.SetID#>|<#=objRow.ItemID#>" >
                        <td class="GridViewLabItemStyle"><#=j+1#></td>
                        <td id="Td1" class="GridViewLabItemStyle" style="display:none"><#=objRow.ID#></td>
                        <td id="SetID" class="GridViewLabItemStyle" style="display:none"><#=objRow.SetID#></td>
                        <td id="SetName" class="GridViewLabItemStyle"><#=objRow.setName#></td>
                        <td id="ItemID" class="GridViewLabItemStyle" style="display:none"><#=objRow.ItemID#></td>
                        <td  id="ItemName" class="GridViewLabItemStyle"><#=objRow.name#></td>
                        <td id="tdSetQuantity" class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.quantity#></td>
                    <td class="GridViewLabItemStyle" id="tdDelete" style="text-align:center;">
                    <img id="imgRmv" src="../../Images/Delete.gif" onclick="DeleteData(this)" onmouseover="chngcur()" title="Click To Remove"/>
                    </td>

                </tr>   

            <#}#>

     </table>    
    </script>
     <script type="text/javascript">
         function DeleteData(rowid) {
             if ($.trim($("#<%=ddlSetItem.ClientID %> ").val()) != "0") {
                 var ID = $(rowid).closest('tr').find("#Td1").text();
                         $.ajax({
                             url: "Lab_itemsSet.aspx/UpdateItem",
                             data: '{ID:"' + ID + '" }', // parameter map
                             type: "POST", // data has to be Posted    	        
                             contentType: "application/json; charset=utf-8",
                             timeout: 120000,
                             dataType: "json",
                             async: false,
                             success: function (result) {
                                 Data = result.d;
                                 if (Data == "1") {
                                     DisplayMsg('MM02', 'spnMsg');
                                     EditItem();
                                 }
                                 else {
                                     DisplayMsg('MM124', 'spnMsg');
                                 }
                                 $("#btnSave").attr('disabled', false);
                             },
                             error: function (xhr, status) {
                                 alert(status + "\r\n" + xhr.responseText);
                                 DisplayMsg('MM05', 'spnMsg');
                                 $("#btnSave").attr('disabled', false);
                                 window.status = status + "\r\n" + xhr.responseText;
                             }
                         });
                 }
             }

         </script>
</asp:Content>