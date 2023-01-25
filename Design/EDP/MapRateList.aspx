<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="MapRateList.aspx.cs" Inherits="Design_EDP_MapRateList" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery-ui.js"></script>
    <script type="text/javascript" src="../../Scripts/json2.js"></script>
     <link href="../../Styles/grid24.css" rel="stylesheet" />

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div style="text-align: center">
                <b>Map Panel Ratelist&nbsp;</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
                <br />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-9">
                            <label class="pull-left"> 
							<asp:RadioButtonList ID="rblType" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static" onchange="hideTableDetail()">
                            <asp:ListItem Text="Investigations" Value="Invst" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Services" Value="Service"></asp:ListItem>
                            <asp:ListItem Text="IPD Packages" Value="Packages"></asp:ListItem>
                            <asp:ListItem Text="Surgery" Value="Surgery"></asp:ListItem>
                        </asp:RadioButtonList>                            </label>                            
                        </div>
                       
                        <div class="col-md-2">
                            <label class="pull-left">Panel
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4"><asp:DropDownList ID="ddlPanel" runat="server" ClientIDMode="Static" TabIndex="1" Width="200px" AutoPostBack="true" OnSelectedIndexChanged="ddlPanel_SelectedIndexChanged"  ></asp:DropDownList>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Rate Schedule Charges
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4"> <asp:DropDownList ID="ddlScheduleCharges" runat="server" Width="200px" ClientIDMode="Static">
                        </asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>


        </div>
       
        <div class="POuter_Box_Inventory" align="center">
            <input type="button" id="btnsearch" class="ItDoseButton" value="Search" onclick="ShowRecord()" style="margin-top:7px;width:100px;" />
        </div>
        <div class="POuter_Box_Inventory" id="showRecord">
            <div class="Purchaseheader" style="text-align: center">
                Details
            </div>
            <table id="tbl1" class="GridViewStyle" cellspacing="0" rules="all" border="1" style="border-collapse:collapse;width:100%;">
                <thead id="idForTr">
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>

    <script type="text/javascript">

        function ShowRecord() {
            var val = $("#rbtnType").SelectedIndex;
            var Panel = $('#ddlPanel').val();
            jQuery.ajax({
                url: "MapRateList.aspx/ShowRecord",
                type: "Post",
                data: "{'Id':'" + $('#ddlPanel').val() + "','Type':'" + $('#rblType').find(':checked').val() + "','Panel':'" + Panel + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var items = jQuery.parseJSON(response.d);
                    if (items != null) {

                        $("#tbl1 tr").remove();
                        $("#idForTr th").remove();
                        var val = Object.keys(items[0])
                        var res = val.toString();
                        var splitvalue = res.split(',');


                        for (var j = 0; j < splitvalue.length; j++) {

                            if (splitvalue[j] == "Id" || splitvalue[j] == "PanelID" || splitvalue[j] == "itemid" || splitvalue[j] == "ScheduleChargeID" || splitvalue[j] == "is_Mapped" || splitvalue[j] == "MappedItem") {

                            }
                            else {

                                $('#idForTr').append('<th class="GridViewHeaderStyle">' + splitvalue[j] + '</th>');
                            }
                        }
                        $('#idForTr').append('<th class="GridViewHeaderStyle"> Mapping Items</th>');
                        $('#idForTr').append('<th class="GridViewHeaderStyle" style="width:200px;"> Mapped Item </th>');
                        for (var i = 0; i < items.length; i++) {
                            $('#tbl1 tbody').append("<tr style='font-size:15px;' class='GridViewLabItemStyle' id='tr" + i + "'></tr>")
                            for (var k = 0; k < splitvalue.length; k++) {
                                var vak = splitvalue[k];
                                if (splitvalue[k] == "Id" || splitvalue[k] == "PanelID" || splitvalue[k] == "itemid" || splitvalue[k] == "ScheduleChargeID" || splitvalue[k] == "is_Mapped" || splitvalue[k] == "MappedItem") {

                                }

                                else {
                                    var itemValue = items[i];
                                    $('#tr' + i + '').append('<td style="text-align:center">' + itemValue[vak] + '</td>');
                                }
                            }
                            $('#tr' + i + '').append('<td style="text-align:center"><input type="text" id="txtMappingItem_' + items[i].Id + '" style="width:100px;" placeholder="Search Here..."/> </td>');
                            $('#tr' + i + '').append('<td style="text-align:center"><span id="spnMappedItemName_' + items[i].Id + '">' + items[i].MappedItem + '</span></td>');

                            $('#txtMappingItem_' + items[i].Id).autocomplete({
                                    source: function (request, response) {
                                    var param = { ItemName: this.element[0].value, Type: $('#rblType').find(':checked').val() };
                                    $.ajax({
                                        url: "MapRateList.aspx/ShowMappingValue",
                                        data: JSON.stringify(param),
                                        dataType: "json",
                                        type: "POST",
                                        contentType: "application/json; charset=utf-8",
                                        dataFilter: function (data) { return data; },
                                        success: function (data) {
                                            response($.map(data.d, function (item) {
                                                return {
                                                    itemID: item.itemID,
                                                    label: item.itemName
                                                }
                                            }))
                                        },
                                        error: function (XMLHttpRequest, textStatus, errorThrown) {
                                            var err = eval("(" + XMLHttpRequest.responseText + ")");
                                            alert(err.Message)
                                        },
                                    });
                                },
                                select: function (event, ui) {
                                    var id = $(this).attr('id').split('_')[1];
                                    var label = ui.item.label.split('(')[0];
                                    var value = ui.item.itemID;
                                    this.value = '';
                                    ui.item.value = ''
                                    FunctionForSaveValue(id, value, label);
                                },
                                minLength: 3
                            });

                        }


                        $('#tbl1 tbody').append("<tr class='GridViewLabItemStyle'><td colspan=" + splitvalue.length + " style='text-align:center'><input type='button' class='ItDoseButton'   id='btnSubmit' onclick='functionForUpdateDetail()' value='Save' style='matgin-top:7px; width:100px;' /></td></tr>")

                       $("#showRecord").show();
                    }
                    else {
                        jQuery("#lblMsg").text("No Record Found");
                        $("#showRecord").hide();
                    }
                },

                error: function (xhr, status) {
                    var err = eval("(" + xhr.responseText + ")");
                    alert(err.Message);
                }
            });
        }

        function FunctionForSaveValue(Id, ItemId, ItemName) {
            var ScheduleChargesValue = $('#ddlScheduleCharges').val();
            if(ItemId!="")
            {
                var Panel = $('#ddlPanel').val();
            jQuery.ajax({
                        url: "MapRateList.aspx/FunctionForSaveValue",
                        type: "Post",
                        data: "{'ItemId':'" + ItemId + "','Id':'" + Id + "','ScheduleChargesValue':'" + ScheduleChargesValue + "','Type':'" + $('#rblType').find(':checked').val() + "','Panel':'" + Panel + "'}",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d == "NotSelected") {
                                $('#txtMappingItem_' + Id).val('');
                                alert("Item already mapped");
                            }
                            else if (response.d == "") {
                                alert("Error...");
                            }
                            else {
                                $('#spnMappedItemName_' + Id).text(ItemName);
                            }
                        },
                        error: function (xhr, status) {
                            var err = eval("(" + xhr.responseText + ")");
                            alert(err.Message);
                        }
                     });
                }
            }



            function functionForUpdateDetail() {
                $('#btnSubmit').attr('disabled', 'disabled');
                var Panel = $('#ddlPanel').val();
                
                jQuery.ajax({
                    url: "MapRateList.aspx/functionForUpdateDetail",
                    type: "Post",
                    data: "{'Type':'" + $('#rblType').find(':checked').val() + "','Panel':'" + Panel + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d != "") {
                            $("#showRecord").hide();
                            $("#lblMsg").text("Record Successfully Saved");
                           
                        }
                        else {
                            $("#lblMsg").text("Error...");
                           
                        }
                        
                    },
                    error: function (xhr, status) {
                        $("#lblMsg").text("Error...");
                       
                      
                    }

                });
                $('#btnSubmit').removeAttr('disabled', 'disabled');
            }


            function hideTableDetail() {
                $("#tbl1 tr").remove();
                $("#idForTr th").remove();
            }

    </script>

</asp:Content>

