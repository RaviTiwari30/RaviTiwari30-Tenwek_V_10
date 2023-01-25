<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OrganisationChart.aspx.cs" Inherits="Design_Biomedicalwaste_OrganisationChart" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <%-- <link href="dist/css/jquery.orgchart.css" rel="stylesheet" />--%>
    <link href="dist/css/jquery.orgchart.min.css" rel="stylesheet" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <link href="../../Styles/DashBoard.css" rel="stylesheet" />
    <%--   <link href="../../Styles/Newcss/style.css" rel="stylesheet" />--%>
    <script src="dist/js/jquery-3.4.1.min.js"></script>
    <%--  <script src="../../Scripts/jquery-1.7.1.min.js"></script>--%>
    <script src="../../Scripts/Common.js"></script>
    <%--  <script src="dist/js/jquery.mockjax.js"></script>--%>
    <script src="dist/js/jquery.orgchart.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var ds = {};
            serverCall('Services/InfrastructureMaster.asmx/Get_OrganigationChart', { data: '' }, function (response) {
                var responseData = JSON.parse(response)
                var dtcentre = responseData.dtcentre;
                var dtblock = responseData.dtBlock;
                var dtBuilding = responseData.dtBuilding
                var dtFloor = responseData.dtFloor
                var dtRoom = responseData.dtRoom
                var dtCubic = responseData.dtCubic




                //---Create Main Node-----
                ds = {
                    'name': 'HIS',
                    'title': '<%= Resources.Resource.ClientFullName%>',
                    'children': []
                };
                //-----Create Centre Nodes
                var Count = 0;
                for (var i = 0; i < dtcentre.length; i++) {
                    ds.children.push({
                        name: 'Center',
                        title: dtcentre[i].Name,
                        id: dtcentre[i].Id,
                        children: []
                    });

                    for (var j = i; j < dtblock.length; j++) {
                        if (dtblock[j].CentreID == ds.children[i].id) {
                            ds.children[i].children.push({
                                name: 'Block',
                                title: dtblock[j].Name,
                                id: dtblock[j].Id,
                                CenterId: dtblock[j].CentreID,
                                children: []
                            });
                        }




                    }

                }

                for (var k = 0; k < ds.children.length; k++) {
                    for (var j = 0; j < ds.children[k].children.length; j++) {
                        for (var i = 0; i < dtBuilding.length; i++) {
                            if (ds.children[k].children.length > 0 && dtBuilding[i].BlockID == ds.children[k].children[j].id) {
                                ds.children[k].children[j].children.push({
                                    name: 'Building',
                                    title: dtBuilding[i].Name,
                                    id: dtBuilding[i].Id,
                                    children: []
                                });
                            }
                        }
                    }
                }
                for (var i = 0; i < ds.children.length; i++) {
                    for (var j = 0; j < ds.children[i].children.length; j++) {
                        debugger;
                        for (var l = 0; l < ds.children[i].children[j].children.length; l++) {

                            for (var k = 0; k < dtFloor.length; k++) {
                                //for (var i = 0; i < dtbuilding.length; i++) {
                                if (ds.children[i].children.length > 0 && ds.children[i].children[j].children.length > 0 && dtFloor[k].BuildingID == ds.children[i].children[j].children[l].id) {

                                    ds.children[i].children[j].children[l].children.push({
                                        name: 'Floor',
                                        title: dtFloor[k].Name,
                                        id: dtFloor[k].Id,
                                        BulidingId: dtFloor[k].BuildingID,
                                        children: []
                                    });
                                }
                            }
                        }
                    }
                }
                for (var i = 0; i < ds.children.length; i++) {
                    for (var j = 0; j < ds.children[i].children.length; j++) {
                        debugger;
                        for (var k = 0; k < ds.children[i].children[j].children.length; k++) {
                            for (var l = 0; l < ds.children[i].children[j].children[k].children.length; l++) {
                                for (var m = 0; m < dtRoom.length; m++) {
                                    //for (var i = 0; i < dtbuilding.length; i++) {
                                    if (ds.children[i].children.length > 0 && ds.children[i].children[j].children.length > 0 && ds.children[i].children[j].children[k].children.length > 0 && dtRoom[m].FloorID == ds.children[i].children[j].children[k].children[l].id && dtRoom[m].BuildingID == ds.children[i].children[j].children[k].children[l].BulidingId) {
                                        ds.children[i].children[j].children[k].children[l].children.push({
                                            name: 'Room',
                                            title: dtRoom[m].Name,
                                            id: dtRoom[m].Id,

                                            //roomid: dtRoom[m].Id,
                                            children: []
                                        });
                                    }
                                }
                            }
                        }
                    }
                }
                for (var k = 0; k < ds.children.length; k++) {
                    for (var j = 0; j < ds.children[k].children.length; j++) {
                        for (var l = 0; l < ds.children[k].children[j].children.length; l++) {
                            for (var m = 0; m < ds.children[k].children[j].children[l].children.length; m++) {
                                for (var n = 0; n < ds.children[k].children[j].children[l].children[m].children.length; n++) {
                                    for (var i = 0; i < dtCubic.length; i++) {
                                        //for (var i = 0; i < dtbuilding.length; i++) {
                                        if (ds.children[k].children.length > 0 && ds.children[k].children[j].children.length > 0 && ds.children[k].children[j].children[l].children.length > 0 && ds.children[k].children[j].children[l].children[m].children.length > 0 && dtCubic[i].RoomId == ds.children[k].children[j].children[l].children[m].children[n].id) {
                                            debugger;
                                            ds.children[k].children[j].children[l].children[m].children[n].children.push({
                                                name: 'Cubical',
                                                title: dtCubic[i].Name,
                                                id: dtCubic[i].Id
                                                //children: []
                                            });
                                        }
                                    }
                                }
                            }
                        }
                    }
                }



                $('#chart-container').orgchart({
                    'visibleLevel': 1,
                    'data': ds,
                    'nodeContent': 'title',
                    'createNode': function ($node, data) {
                        $node.on('click', '.bottomEdge', function (event) {
                            if ($(event.target).is('.fa-chevron-down')) {
                                showDescendents(this, 3);
                            }
                        });
                    }
                });
                $('#chart-container').find('.node').on('click', function () {
                    debugger;
                    var flag = 0;
                    var Id = 0;
                    var Buildingid = 0;
                    var aa = JSON.stringify($(this).data('nodeData').name).split('"');
                    var Name = aa[1];
                    if (Name == "Room") {
                        Id = JSON.stringify($(this).data('nodeData').id);
                        flag = 0;
                    }
                    else if (Name == "Cubical") {
                        Id = JSON.stringify($(this).data('nodeData').id);
                        flag = 1;
                    }
                    else if (Name == "Floor") {
                        Id = JSON.stringify($(this).data('nodeData').id);
                        Buildingid = JSON.stringify($(this).data('nodeData').BulidingId);
                        flag = 2;
                    }
                    if (Name == "Room" || Name == "Cubical" || Name == "Floor") {
                        var data = {
                            Id: Id,
                            flag: flag,
                            Buildingid: Buildingid,
                        }
                        serverCall('Services/InfrastructureMaster.asmx/GetRoomCubicalDetailsById', data, function (response) {
                            debugger;
                            var responseData = JSON.parse(response);
                            if (responseData.length > 0)
                                BindDetail(responseData, flag);
                            else
                                modelAlert('No Asset Found');

                        });
                    }

                });
                $("#btn-filter-node").on("click", function () {
                    filterNodes($("#key-word").val());
                });
                $("#btn-cancel").on("click", function () {
                    clearFilterResult();
                });

                var showDescendents = function (node, depth) {
                    if (depth === 1) {
                        return false;
                    }
                    $(node).closest('tr').siblings(':last').children().find('.node:first').each(function (index, node) {
                        var $temp = $(node).closest('tr').siblings().removeClass('hidden');
                        var $children = $temp.last().children().find('.node:first');
                        if ($children.length) {
                            $children[0].style.offsetWidth = $children[0].offsetWidth;
                        }
                        $children.removeClass('slide-up');
                        showDescendents(node, depth--);
                    });
                };


                //$("#key-word").on("keyup", function (event) {
                //    debugger;
                //    filterNodes(this.value);

                //});
            });
        });



        function BindDetail(data, flag) {

            if (flag == "0" || flag == "1") {

                $('td:nth-child(5),th:nth-child(5)').hide();

            }
            else {
                $('td:nth-child(5),th:nth-child(5)').show();
            }
            $('#divDetail').showModel();
            $('#tbsearch tbody').empty();
            var row = '';
            for (var i = 0; i < data.length; i++) {
                var j = $('#tbsearch tbody tr').length + 1;
                row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdBagame" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].AssetName + '</td>';
                row += '<td id="tdBagColour" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].AssetNo + '</td>';
                row += '<td id="tdBagDesc" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].LocationName + '</td>';
                if (flag != "0" && flag != "1") {
                    row += '<td id="tdBagDesc" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].RoomName + '</td>';
                }
                //if (flag == 3) {
                //    row += '<td id="tdBagDesc" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].RoomName + '</td>';
                //}
                //else {
                //    row += '<td id="tdBagDesc" class="GridViewLabItemStyle" style="text-align: center;"></td>';
                //}
                row += '<td id="tdBagDesc" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CubicalName + '</td>';
                row += '</tr>';
                $('#tbsearch tbody').append(row);
            }
        }

        function SearchNode(ctrl) {
            debugger;
            if (ctrl.value != '')
                filterNodes(ctrl.value);
            else
                clearFilterResult();
        }

        function filterNodes(keyWord) {
            debugger;
            if (!keyWord.length) {
                modelAlert("Please Enter Any Keyword");
                //window.alert("Please type key word firstly.");
                return;
            } else {
                var $chart = $(".orgchart");
                // disalbe the expand/collapse feture
                $chart.addClass("noncollapsable");
                // distinguish the matched nodes and the unmatched nodes according to the given key word
                $chart
                  .find(".node")
                  .filter(function (index, node) {
                      return (
                        $(node)
                          .text()
                          .toLowerCase()
                          .indexOf(keyWord) > 2
                      );
                  })
                  .addClass("matched")
                  .closest("table")
                  .parents("table")
                  .find("tr:first")
                  .find(".node")
                  .addClass("retained");
                // hide the unmatched nodes
                $chart.find(".matched,.retained").each(function (index, node) {
                    $(node)
                      .removeClass("slide-up")
                      .closest(".nodes")
                      .removeClass("hidden")
                      .siblings(".lines")
                      .removeClass("hidden");
                    var $unmatched = $(node)
                      .closest("table")
                      .parent()
                      .siblings()
                      .find(".node:first:not(.matched,.retained)")
                      .closest("table")
                      .parent()
                      .addClass("hidden");
                    $unmatched
                      .parent()
                      .prev()
                      .children()
                      .slice(1, $unmatched.length * 2 + 1)
                      .addClass("hidden");
                });
                // hide the redundant descendant nodes of the matched nodes
                $chart.find(".matched").each(function (index, node) {
                    if (
                      !$(node)
                        .closest("tr")
                        .siblings(":last")
                        .find(".matched").length
                    ) {
                        $(node)
                          .closest("tr")
                          .siblings()
                          .addClass("hidden");
                    }
                });
            }
        }
        function clearFilterResult() {
            $('[id$=key-word]').val('');
            $(".orgchart")
              .removeClass("noncollapsable")
              .find(".node")
              .removeClass("matched retained")
              .end()
              .find(".hidden")
              .removeClass("hidden")
              .end()
              .find(".slide-up, .slide-left, .slide-right")
              .removeClass("slide-up slide-right slide-left");
        }
    </script>
    <style>
        #chart-container
        {
            font-family: Arial;
            height: 550px;
            /*border: 2px dashed #aaa;*/
            border-radius: 5px;
            overflow-y: auto;
            /*overflow: auto;*/
            /*text-align: center;*/
        }

        /*#github-link {
            position: fixed;
            top: 0px;
            right: 10px;
            font-size: 3em;
        }*/
        #edit-panel
        {
            text-align: center;
            position: relative;
            left: 10px;
            width: calc(100% - 40px);
            border-radius: 4px;
            float: left;
            margin-top: 10px;
            padding: 10px;
            color: #fff;
            background-color: #449d44;
        }

        /*#edit-panel * {
                font-size: 20px;
            }*/
    </style>
</head>
<body>

    <form id="form1" runat="server">
        <div id="chart-container">
        </div>
        <div id="edit-panel" class="view-state">
            <input type="text" id="key-word" autocomplete="off" onkeyup="SearchNode(this)" />
            <button type="button" id="btn-filter-node">Search</button>
            <button type="button" id="btn-cancel">Clear</button>
        </div>

        <div id="divDetail" class="modal fade ">
            <div class="modal-dialog">
                <div class="modal-content" style="background-color: white; width: 613px; height: 220px;">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divDetail" aria-hidden="true">&times;</button>
                        <h4 class="modal-title"><span id="spnHeading">Asset Details</span></h4>
                        <span class="hidden" id="SpnDocumentID"></span>
                    </div>
                    <div class="modal-header">
                        <div id="divList" style="max-height: 400px; overflow-x: auto">
                            <table class="FixedHeader" id="tbsearch" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                                <thead>
                                    <tr>
                                        <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                        <th class="GridViewHeaderStyle" style="width: 150px;">Asset Name</th>
                                        <th class="GridViewHeaderStyle" style="width: 150px;">Asset No</th>
                                        <th class="GridViewHeaderStyle" style="width: 150px;">Location</th>
                                        <th class="GridViewHeaderStyle" style="width: 150px;">Room Name</th>
                                        <th class="GridViewHeaderStyle" style="width: 150px;">Cubical Name</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                    <div class="modal-footer">

                        <button type="button" data-dismiss="divDetail">Close</button>
                    </div>
                </div>
            </div>
        </div>


    </form>
</body>
</html>
