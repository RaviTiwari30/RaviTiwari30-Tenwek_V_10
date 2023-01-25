<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="PanelDiscMaster.aspx.cs" Inherits="Design_EDP_PanelDiscMaster" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="../../Scripts/json2.js" type="text/javascript"></script>
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
   
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sm" runat="server" />
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Set Panel Discount </b>
            <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label></div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                &nbsp;</div>

            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                 Panel Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlPanel" runat="server"> 
                        </asp:DropDownList>
                        </div>
                          <div class="col-md-3">
                            <label class="pull-left">
                                Category
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlCategory" runat="server" Width="95%">
                        </asp:DropDownList>
                        <span style="color: red; font-size: 10px;">*</span>
                        </div>
                            <div class="col-md-3">
                            <label class="pull-left">
                                <asp:Label ID="lblPanelDisc" runat="server" Text="" ClientIDMode="Static"></asp:Label>
                            </label>
                            
                        </div>
                        <div class="col-md-5">
                            <input id="txtPanelDisc" class="ItDoseTextinputNum" onkeypress="return checkForSecondDecimal(this,event)" type="text" style="display: none" onkeyup="Check(this);" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
       
       
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Details
            </div>
            <div id="PanelDiscOutput" style="max-height: 500px; overflow-x: auto; text-align: center">
            </div>
            <br />
            <asp:Panel ID="pnlHide" runat="server" Style="display: none; text-align:center">

                   
                    <input type="button" id="Save" value="Save" style="display: none" onclick="save();"
                        class="ItDoseButton" />
            </asp:Panel>
        </div>
    </div>
    <script id="tb_PanelDiscDetail" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_PanelDiscSearch"
    style="width:100%;border-collapse:collapse;text-align:center">
		<tr id="DiscHeader">
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:240px;">SubCategory Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">Percentage %</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:140px;display:none">SubCategory ID</th>             
            <th class="GridViewHeaderStyle" scope="col" style="width:60px; display:none"></th>
</tr>

       <#

              var dataLength=panelDiscData.length;
              var objRow;
        for(var j=0;j<dataLength;j++)
        {

        objRow = panelDiscData[j];

            #>
                    <tr id="<#=j+1#>">
<td class="GridViewLabItemStyle"><#=j+1#></td>
<td id="<#=objRow.subCategoryID#>"  class="GridViewLabItemStyle"><#=objRow.Name#></td>

<td class="GridViewLabItemStyle"><input id="txt_Percentage"  class="ItDoseTextinputNum" type="text" onkeypress="return checkForSecondDecimal(this,event)" value="<#=objRow.percentage#>" style="width:90px;" onkeyup="CheckQty(this);" />%
 <span id="spnPer" style="display:none" ><#=objRow.percentage#></span>
   <span id="spnPerCon" style="display:none"   />
    
</td>
                        <td class="GridViewLabItemStyle" id="tdSubCategoryID" style="display:none">
                            <#=objRow.subCategoryID#>
                        </td>
                        
                        <td class="GridViewLabItemStyle" style="width:60px; display:none">
                            
                           

                            <input type="button" id="btnItem" value="Item Wise" class="ItDoseButton" onclick="bindItem(this)" />
                   
                              </td>
</tr>

            <#}#>
     </table>
    </script>

    <script type="text/javascript">
        function bindItem(rowID) {
            var subCategoryID = $(rowID).closest('tr').find("#tdSubCategoryID").text().trim();
            $.ajax({
                type: "post",
                data: '{subCategoryID:"' + subCategoryID + '",PanelID:"' + $("#<%=ddlPanel.ClientID %>").val() + '",CategoryID:"' + $("#<%=ddlCategory.ClientID %>").val() + '"}',
                url: "PanelDiscMaster.aspx/bindDiscItemWise",
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                timeout: 120000,
                async: false,
                success: function (result) {
                    itemData = jQuery.parseJSON(result.d);
                    if (itemData != null) {
                        var output = $("#tb_ItemDetail").parseTemplate(itemData);
                        $("#ItemOutput").html(output);
                        $("#ItemOutput").show();
                        $find('mpItem').show();
                    }

                },
                error: function (xhr, status) {
                    $("#<%=lblmsg.ClientID %>").text('Error occurred, Please contact administrator');
                }

            });
            }
            function fillAllItemPer(rowID) {
                if (parseFloat($(".DeActive").text()) == "0") {
                    $(".itemPer").val(rowID);
                    if (rowID > 100) {
                        alert('Please Enter Valid Percentage');
                        $(".itemPer,.itemHeaderPer").val(0);
                        return;
                    }
                }
                if (rowID.indexOf('.') != -1) {
                    var DigitsAfterDecimal = 2;
                    var valIndex = rowID.indexOf(".");
                    if (valIndex > "0") {
                        if (rowID.length - (rowID.indexOf(".") + 1) > DigitsAfterDecimal) {
                            alert("Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                            $(".itemPer,.itemHeaderPer").val($(".itemPer,.itemHeaderPer").val().substring(0, ($(".itemPer,.itemHeaderPer").val().length - 1)));

                            return false;
                        }
                    }
                }
                else {
                    $(".itemPer").val();
                    $(".clItemPerCon").text('1');
                }
                if (($(".itemHeaderPer").val().charAt(0) == "0") || ($(".itemHeaderPer").val().charAt(0) == "")) {
                    $(".itemPer,.itemHeaderPer").val(0);
                }
            }
            function chkAllPer() {
                if ($(".chkPer").is(':checked')) {
                    $(".itemHeaderPer").show();
                }
                else {
                    $(".itemHeaderPer").val('').hide();
                    $(".itemPer").val('0');
                }
            }
    </script>
    <cc1:ModalPopupExtender ID="mpItem" runat="server" BackgroundCssClass="filterPupupBackground"
                    CancelControlID="btnRCancel" DropShadow="true" PopupControlID="pnlItem"  
                    TargetControlID="btnNew"   BehaviorID="mpItem" OnCancelScript="hideItem()">
                </cc1:ModalPopupExtender>  
    <asp:Button ID="btnNew" runat="server" style ="display:none" />
    <asp:Panel ID="pnlItem" runat="server" CssClass="pnlItemsFilter" Style="display: none" 
                    Width="640px" >
                 <div id="Div1"  class="Purchaseheader"  runat="server" style="text-align:right">  
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              <em ><span style="font-size: 7.5pt"> Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor:pointer"  onclick="hideItem()" />
                               
                                to close</span></em>
                    </div>
          <div id="ItemOutput" style="max-height: 500px; overflow-x: auto; text-align: center">
            </div>
                    <table style="width:100%">
                       
                            <tr>
                            <td colspan="2" style="text-align:center">
                                <input type="button" onclick="saveItem();" value="Save" class="ItDoseButton" id="btnSaveItem" title="Click To Save" />
                                &nbsp;
                                    <asp:Button ID="btnRCancel" runat="server" CssClass="ItDoseButton" Text="Cancel"
                                        ToolTip="Click To Cancel" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>

    <script id="tb_ItemDetail" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_DocShareItem"
    style="width:600px;border-collapse:collapse;text-align:center">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:240px;">Item Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;">Percentage %
                <input type="checkbox" class="chkPer"  onclick="chkAllPer()"/>
			</th>
            
            <th class="GridViewHeaderStyle" scope="col" style="width:240px;display:none">ItemID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:240px;display:none">SubCategoryID</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">IsActive</th>
</tr>
            <tr id="itemHeader" >
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;"></th>
            <th class="GridViewHeaderStyle" scope="col" style="width:240px;"></th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">
                <input type="text"   style="display:none;width:90px" class="ItDoseTextinputNum itemHeaderPer" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="fillAllItemPer(this.value)"/>

            </th>
                </tr>

       <#

              var dataLength=itemData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;
        for(var j=0;j<dataLength;j++)
        {

        objRow = itemData[j];

            #>
                    <tr id="Tr1"  
                        <# if(itemData[j].IsActive =="1")
                        {#>                      
                        style="background-color:#FFB6C1" <#} 
                       
                         #>>        
<td class="GridViewLabItemStyle"><#=j+1#></td>
<td id="tdItemName"  class="GridViewLabItemStyle"><#=objRow.Name#></td>

<td class="GridViewLabItemStyle" style="width:120px;">
     
    <input id="txtItemPer" type="text" onkeypress="return checkForSecondDecimal(this,event)" value="<#=objRow.percentage#>" style="width:90px;" onkeyup="CheckPer(this);"
         class="ItDoseTextinputNum 
         <#if($.trim(itemData[j].IsActive) =="1")                                
                                 {#> NotitemPer"  <#}
                                 else{#>  itemPer"  <#} #> />%
         
    <span id="spnItemPer" style="display:none" ><#=objRow.percentage#></span>
   <span id="spnItemPerCon" style="display:none" class="clItemPerCon"   />
</td>
                       
                        <td id="tdItemID" style="display:none">
                            <#=objRow.ItemID#>
                        </td>
                         <td id="tdSubCatID" style="display:none">
                            <#=objRow.subCategoryID#>
                        </td>
                         <td id="tdIsActive" class="isActive" style="display:none">
                            
                             <span id="spnActive"                                                                
                                 <#if($.trim(itemData[j].IsActive) =="1")                                
                                 {#> class="IsActive" <#}
                                 else{#> class="DeActive" <#} #> ><#=objRow.IsActive#>                                 
                             </span>
                        </td>
</tr>

            <#}#>
     </table>
    </script>
    <script type="text/javascript">
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find('mpItem')) {
                    $find('mpItem').hide();
                }
            }
        }
        function hideItem() {
            $find('mpItem').hide();
        }
    </script>


     <script type="text/javascript">


         $(document).ready(function () {
             $("table[id*=grdSubCategory] input[id*=txtSubCatPercentage]").bind('keyup keydown', function (e) {
                 var Per = parseFloat($(this).closest("tr").find("input[id*=txtSubCatPercentage]").val());
                 if (isNaN(Per)) Per = 0;
                 if (Per > 100) {
                     $(this).closest("tr").find("input[id*=txtSubCatPercentage]").val('0');
                     $(this).closest("tr").find("input[id*=txtSubCatPercentage]").focus();
                     return false;
                 }
                 if ($(this).closest("tr").find("input[id*=txtSubCatPercentage]").val().charAt(0) == "0") {

                 }
                 var DigitsAfterDecimal = 2;
                 var valIndex = Per.indexOf(".");

                 if (valIndex > "0") {
                     if (Per.length - (Per.indexOf(".") + 1) > DigitsAfterDecimal) {
                         alert("Please Enter Valid Percentage Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                         $("input[id*=txtSubCatPercentage]").val($("input[id*=txtSubCatPercentage]").val().substring(0, ($("input[id*=txtSubCatPercentage]").val().length - 1)));

                     }
                 }
             });

         });

    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#<%=ddlCategory.ClientID %>").get(0).selectedIndex = 0;
            $("#<%=ddlPanel.ClientID %>").get(0).selectedIndex = 0;
            $("#txtPanelDisc").bind('keyup', function () {
                $("#tb_PanelDiscSearch :text").val($("#txtPanelDisc").val());

            });
        });
        $(function () {
            $("#<%=ddlCategory.ClientID %>").change(function () {
                $("#<%=lblmsg.ClientID %>").text('');
                if ($("#<%=ddlCategory.ClientID %>").val() != "Select") {
                    search($("#<%=ddlPanel.ClientID %>").val(), $("#<%=ddlCategory.ClientID %>").val());
                }
                else {
                    $("#<%=lblmsg.ClientID %>").text('Please Select Category');
                    $("#Save,#txtPanelDisc,#tb_PanelDiscSearch,#lblPanelDisc").hide();
                    return;
                }
            });
            $("#<%=ddlPanel.ClientID %>").change(function () {
                $("#<%=lblmsg.ClientID %>").text('');
                if ($("#<%=ddlCategory.ClientID %>").val() != "Select") {
                    search($("#<%=ddlPanel.ClientID %>").val(), $("#<%=ddlCategory.ClientID %>").val());
                }
                else {
                    $("#<%=lblmsg.ClientID %>").text('Please Select Category');
                    $("#Save,#txtPanelDisc,#tb_PanelDiscSearch").hide();
                    return;
                }
            });
        });
        </script>
        <script type="text/javascript">
            function search(PanelID, Category) {
                $.ajax({
                    type: "post",
                    data: '{PanelID:"' + PanelID + '",Category:"' + Category + '"}',
                    url: "PanelDiscMaster.aspx/bindPanelDisc",
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    timeout: 120000,
                    async: false,
                    success: function (result) {
                        panelDiscData = jQuery.parseJSON(result.d);
                        if (panelDiscData != null) {
                            var output = $("#tb_PanelDiscDetail").parseTemplate(panelDiscData);
                            $("#PanelDiscOutput").html(output);
                            $("#PanelDiscOutput").show();
                            $("#<%=lblPanelDisc.ClientID %>").text("Panel Disc. : ");
                        $("#txtPanelDisc,#Save,#tb_PanelDiscSearch,#lblPanelDisc").show();
                        $("#<%=pnlHide.ClientID %>").show();
                        $('#btnSave').attr('disabled', false).val("Save");
                        $("#txtPanelDisc").val('');
                        $("#<%=lblmsg.ClientID %>").text('');

                    }
                    else {
                        $("#PanelDiscOutput").html('');
                        $("#PanelDiscOutput").hide();
                        $("#<%=lblPanelDisc.ClientID %>").text('');
                        $("#txtPanelDisc").attr({ value: '' });
                        $("#Save,#txtPanelDisc,#tb_PanelDiscSearch,#lblPanelDisc").hide();
                        $("#<%=pnlHide.ClientID %>").hide();
                        $('#btnSave').attr('disabled', true).val("Save");
                        $("#<%=lblmsg.ClientID %>").text('No Record Found');

                    }
                },
                error: function (xhr, status) {
                }
            });
        }
        function getPanelDiscDetail() {
            var dataItem = new Array();
            var ObjItem = new Object();
            $("#tb_PanelDiscSearch tr").each(function () {
                var id = $(this).attr("id");
                var $rowid = $(this).closest("tr");

                if ((id != "DiscHeader") && ($.trim($rowid.find("#txt_Percentage").val()) > 0)) {
                    ObjItem.Percentage = $.trim($rowid.find("#txt_Percentage").val());
                    ObjItem.SubCategoryID = $.trim($rowid.find("#tdSubCategoryID").text());
                    if (parseFloat($rowid.find("#spnPer").text()) > 0)
                        ObjItem.IsActive = 1;
                    else
                        ObjItem.IsActive = 0;
                    dataItem.push(ObjItem);
                    ObjItem = new Object();
                }

            });

            return dataItem;
        }
        function save() {
            $("#<%=lblmsg.ClientID %>").text('');
            $('#Save').attr('disabled', true).val("Submitting...");

            var result = getPanelDiscDetail();

            if (result.length > 0) {
                $.ajax({
                    url: "PanelDiscMaster.aspx/savePanelDisc",
                    data: JSON.stringify({ item: result, CategoryID: $("#<%=ddlCategory.ClientID %>").val(), PanelID: $("#<%=ddlPanel.ClientID %>").val() }),
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        if (result.d == "1") {
                            $("#<%=lblmsg.ClientID %>").text('Record Saved Successfully');
                            $("#<%=lblPanelDisc.ClientID %>").text('');
                            $("#txtPanelDisc").attr({ value: '' });
                            $("#Save,#txtPanelDisc,#tb_PanelDiscSearch").hide();
                            $("#<%=ddlCategory.ClientID %>").get(0).selectedIndex = 0;
                            $("#<%=ddlPanel.ClientID %>").get(0).selectedIndex = 0;
                        }

                        else {
                            $("#<%=lblmsg.ClientID %>").text('Record Not Saved');
                        }
                        $('#Save').attr('disabled', false).val("Save");
                    },
                    error: function (xhr, status) {
                        $("#<%=lblmsg.ClientID %>").text('Record Not Saved');
                        $('#Save').attr('disabled', false).val("Save");
                    }
                });
                }
                else {
                    $('#Save').attr('disabled', false).val("Save");
                }


            }
         </script>
        <script type="text/javascript">
            function checkForSecondDecimal(sender, e) {
                formatBox = document.getElementById(sender.id);
                strLen = sender.value.length;
                strVal = sender.value;
                hasDec = false;
                e = (e) ? e : (window.event) ? event : null;

                if (e) {
                    var charCode = (e.charCode) ? e.charCode :
                                ((e.keyCode) ? e.keyCode :
                                ((e.which) ? e.which : 0));

                    if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                        for (var i = 0; i < strLen; i++) {
                            hasDec = (strVal.charAt(i) == '.');
                            if (hasDec)
                                return false;
                        }
                    }
                }
                return true;
            }
            function CheckQty(Qty) {
                var Amt = $(Qty).val();
                if (Amt.charAt(0) == "0") {
                    $(Qty).val(Number(Amt));
                }

                if (Amt.match(/[^0-9\.]/g)) {
                    Amt = Amt.replace(/[^0-9\.]/g, '');
                    $(Qty).val(Number(Amt));
                    return;
                }
                if (Amt > 100) {
                    alert('Please Enter Valid Percentage');
                    $(Qty).val(0);
                    return;
                }
                if (Amt.indexOf('.') != -1) {
                    var DigitsAfterDecimal = 2;
                    var valIndex = Amt.indexOf(".");
                    if (valIndex > "0") {
                        if (Amt.length - (Amt.indexOf(".") + 1) > DigitsAfterDecimal) {
                            alert("Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                            $(Qty).val($(Qty).val().substring(0, ($(Qty).val().length - 1)));
                            return false;
                        }
                    }
                }
                if (Amt == 0) {
                    $(Qty).val(0);
                    return;
                }
            }

            function Check(Qty) {
                var Amt = $(Qty).val();
                if (Amt.match(/[^0-9\.]/g)) {
                    Amt = Amt.replace(/[^0-9\.]/g, '');
                    $(Qty).val(Number(Amt));
                    return;
                }
                if (Amt.charAt(0) == "0") {
                    $(Qty).val(Number(Amt));
                }

                if (Amt > 100) {
                    alert('Please Enter Valid Percentage');
                    $(Qty).val(0);
                    return;
                }
                if (Amt.indexOf('.') != -1) {
                    var DigitsAfterDecimal = 2;
                    var valIndex = Amt.indexOf(".");
                    if (valIndex > "0") {
                        if (Amt.length - (Amt.indexOf(".") + 1) > DigitsAfterDecimal) {
                            alert("Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                            $(Qty).val($(Qty).val().substring(0, ($(Qty).val().length - 1)));
                            return false;
                        }
                    }
                }
                if (Amt == "") {
                    $(Qty).val(0);
                    return;
                }
            }
    </script>
</asp:Content>